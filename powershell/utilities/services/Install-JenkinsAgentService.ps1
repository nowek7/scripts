# Global Constants
$AGENT_JAR_URL = "<url>/agent.jar"
$CLOUDBEES_DIR = "C:\CloudBees"
$SERVICE_NAME = "JenkinsAgent"
$SERVICE_LOG = "$CLOUDBEES_DIR\service.log"
$SERVICE_ERROR_LOG = "$CLOUDBEES_DIR\service-error.log"
$AGENT_STARTUP_FILE = "$CLOUDBEES_DIR\agentStartup.bat"

function New-JenkinsEnvironment {
    [CmdletBinding()]
    Param()

    try {
        Write-Host "Setting up Jenkins environment..."

        # Ensure the CloudBees directory exists
        if (-not (Test-Path -Path $CLOUDBEES_DIR)) {
            Write-Host "Creating CloudBees directory at $CLOUDBEES_DIR..."
            New-Item -Path $CLOUDBEES_DIR -ItemType Directory -Force
        }

        # Ensure log files exist
        foreach ($file in @($SERVICE_LOG, $SERVICE_ERROR_LOG)) {
            if (-not (Test-Path -Path $file)) {
                Write-Host "Creating log file: $file"
                New-Item -Path $file -ItemType File -Force
            }
        }

        # Download agent.jar
        Write-Host "Downloading agent.jar to $CLOUDBEES_DIR..."
        Invoke-WebRequest -Uri $AGENT_JAR_URL -OutFile "$CLOUDBEES_DIR\agent.jar" -ErrorAction Stop

        # Create agentStartup.bat
        Write-Host "Creating agentStartup.bat..."
        $agentStartupContent = @(
            'SET HTTP_PROXY= ',
            '',
            'cmd /k java -Djenkins.websocket.pingInterval=15 -jar agent.jar -webSocket -url <url> -secret <secret> -name <hostname> -workDir "<workDir>"'
        )
        Set-Content -Path $AGENT_STARTUP_FILE -Value $agentStartupContent -Force

        Write-Host "Jenkins environment setup completed successfully." -ForegroundColor Green
    } catch {
        Write-Error "An error occurred during Jenkins environment setup: $_"
    }
}

function Install-JenkinsService {
    [CmdletBinding()]
    Param()

    Write-Host "Installing Jenkins Agent service using nssm..."

    # Check if nssm is installed
    if (-not (Get-Command nssm.exe -ErrorAction SilentlyContinue)) {
        Write-Error "nssm is not installed or not available in the PATH. Please install nssm before running this script."
        return
    }

    # Configure the Jenkins service using nssm
    try {
        nssm install $SERVICE_NAME $serviceExecutable
        nssm set $SERVICE_NAME AppDirectory $CLOUDBEES_DIR
        nssm set $SERVICE_NAME DisplayName 'Jenkins Agent'
        nssm set $SERVICE_NAME Description 'This service is responsible for executing build jobs dispatched by the CloudBees Jenkins Controller.'
        nssm set $SERVICE_NAME Start SERVICE_DELAYED_AUTO_START
        nssm set $SERVICE_NAME AppStdout $serviceLogPath
        nssm set $SERVICE_NAME AppStderr $serviceErrorLogPath
        nssm set $SERVICE_NAME AppRotateFiles 1
        nssm set $SERVICE_NAME AppRotateBytes 16777216

        # Configure service failure actions
        $resetFailCount = 5 * 24 * 60 * 60 # 5 days
        $timeRestart = 60 * 1000 # 1 minute
        sc.exe failure $SERVICE_NAME reset=$resetFailCount actions= restart/$timeRestart/restart/$timeRestart//

        Write-Host "Jenkins Agent service installed successfully." -ForegroundColor Green
    } catch {
        Write-Error "An error occurred while installing Jenkins Agent service: $_"
    }
}

# Main
New-JenkinsEnvironment
Install-JenkinsService
