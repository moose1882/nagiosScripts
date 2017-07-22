@echo off
echo ^<^<^<winperf_if:sep^(44^)^>^>^> 
wmic path Win32_NetworkAdapter get macaddress,name,netconnectionid,netconnectionstatus /format:"%WINDIR%\System32\wbem\en-us\csv"
