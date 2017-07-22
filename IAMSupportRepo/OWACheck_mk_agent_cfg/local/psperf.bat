@echo off
rem This plugin obsoletes wmicchecks.bat. It is better because it is
rem directly supported by the normal ps check.

echo ^<^<^<ps:sep^(44^)^>^>^>
echo [wmic process]
wmic process get ProcessId,name,pagefileusage,virtualsize,workingsetsize,usermodetime,kernelmodetime,ThreadCount,HandleCount /format:"%WINDIR%\System32\wbem\en-us\csv"
echo [wmic process end]