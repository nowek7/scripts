# Quad9 - https://www.quad9.net/
Set-DnsClientServerAddress -InterfaceIndex 13 -ServerAddresses ("9.9.9.9","149.112.112.112")
Set-DnsClientServerAddress -InterfaceIndex 13 -ServerAddresses ("2620:fe::fe","2620:fe::9")

ipconfig /flushdns
ipconfig /registerdns
