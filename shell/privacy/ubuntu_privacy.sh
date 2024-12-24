#!/usr/bin/env bash

disable_metrics_reporting()
{
    echo '*** Disable participation in metrics reporting in Ubuntu'
    if ! command -v 'ubuntu-report' &> /dev/null; then
        echo 'Skipping because "ubuntu-report" is not found.'
    else
        if ubuntu-report -f send no; then
            echo 'Successfully opted out.'
        else
            >&2 echo 'Failed to opt out.'
        fi
    fi
}

remove_ubuntu_report_tool()
{
    echo "*** Remove Ubuntu Report tool ('ubuntu-report')"
    if ! command -v 'apt-get' &> /dev/null; then
        echo 'Skipping because "apt-get" is not found.'
    else
        apt_package_name='ubuntu-report'
        if status="$(dpkg-query -W --showformat='${db:Status-Status}' "$apt_package_name" 2>&1)" && [ "$status" = installed ]; then
            echo "\"$apt_package_name\" is installed and will be uninstalled."
            sudo apt-get purge -y "$apt_package_name"
        else
            echo "Skipping, no action needed, \"$apt_package_name\" is not installed."
        fi
    fi
}

disable_apport_service()
{
    echo '*** Disable Apport service'
    if ! command -v 'systemctl' &> /dev/null; then
        echo 'Skipping because "systemctl" is not found.'
    else
        service='apport'
        if systemctl list-units --full -all | grep --fixed-strings --quiet "$service"; then # service exists
            if systemctl is-enabled --quiet "$service"; then
                if systemctl is-active --quiet "$service"; then
                    echo "Service $service is running now, stopping it."
                    if ! sudo systemctl stop "$service"; then
                        >&2 echo "Could not stop $service."
                    else
                        echo 'Successfully stopped'
                    fi
                fi

                if sudo systemctl disable "$service"; then
                    echo "Successfully disabled $service."
                else
                    >&2 echo "Failed to disable $service."
                fi
            else
                echo "Skipping, $service is already disabled."
            fi
        else
            echo "Skipping, $service does not exist."
        fi
    fi
}

remove_apport_package()
{
    echo "--- Remove 'apport' package"
    if ! command -v 'apt-get' &> /dev/null; then
        echo 'Skipping because "apt-get" is not found.'
    else
        apt_package_name='apport'
        if status="$(dpkg-query -W --showformat='${db:Status-Status}' "$apt_package_name" 2>&1)" && [ "$status" = installed ]; then
            echo "\"$apt_package_name\" is installed and will be uninstalled."
            sudo apt-get purge -y "$apt_package_name"
        else
            echo "Skipping, no action needed, \"$apt_package_name\" is not installed."
        fi
    fi
}

disable_participation_apport_error_system()
{
    echo '*** Disable participation in Apport error messaging system'
    if [ -f /etc/default/apport ]; then
        sudo sed -i 's/enabled=1/enabled=0/g' /etc/default/apport
        echo 'Successfully disabled apport.'
    else
        echo 'Skipping, apport is not configured to be enabled.'
    fi
}

disable_whoopsie_service()
{
    echo '*** Disable Whoopsie service'

    if ! command -v 'systemctl' &> /dev/null; then
        echo 'Skipping because "systemctl" is not found.'
    else
        service='whoopsie'
        if systemctl list-units --full -all | grep --fixed-strings --quiet "$service"; then # service exists
            if systemctl is-enabled --quiet "$service"; then
                if systemctl is-active --quiet "$service"; then
                    echo "Service $service is running now, stopping it."
                    if ! sudo systemctl stop "$service"; then
                        >&2 echo "Could not stop $service."
                    else
                        echo 'Successfully stopped'
                    fi
                fi

                if sudo systemctl disable "$service"; then
                    echo "Successfully disabled $service."
                else
                    >&2 echo "Failed to disable $service."
                fi
            else
                echo "Skipping, $service is already disabled."
            fi
        else
            echo "Skipping, $service does not exist."
        fi
    fi
}

remove_whoopsie_package()
{
    echo "*** Remove 'whoopsie' package"
    if ! command -v 'apt-get' &> /dev/null; then
        echo 'Skipping because "apt-get" is not found.'
    else
        apt_package_name='whoopsie'
        if status="$(dpkg-query -W --showformat='${db:Status-Status}' "$apt_package_name" 2>&1)" && [ "$status" = installed ]; then
            echo "\"$apt_package_name\" is installed and will be uninstalled."
            sudo apt-get purge -y "$apt_package_name"
        else
            echo "Skipping, no action needed, \"$apt_package_name\" is not installed."
        fi
    fi
}

disable_crash_report_submission()
{
    echo '*** Disable crash report submissions'
    if [ -f /etc/default/whoopsie ] ; then
        sudo sed -i 's/report_crashes=true/report_crashes=false/' /etc/default/whoopsie
    fi
}

disable_search_result_collection()
{
    echo '*** Disable online search result collection (collects queries)'
    if ! command -v 'gsettings' &> /dev/null; then
        echo 'Skipping because "gsettings" is not found.'
    else
        gsettings set com.canonical.Unity.Lenses remote-content-search none
    fi
}

disable_metrics_reporting
remove_ubuntu_report_tool
disable_apport_service
remove_apport_package
disable_participation_apport_error_system
disable_whoopsie_service
remove_whoopsie_package
disable_crash_report_submission
disable_search_result_collection

echo 'Press any key to exit.'
read -nr 1 -s
