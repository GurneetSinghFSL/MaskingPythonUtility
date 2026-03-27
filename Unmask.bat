@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "CONFIG_FILE=%SCRIPT_DIR%utility-config.json"
set "BUNDLED_EXE=%SCRIPT_DIR%bin\MaskingUtility.exe"
set "PY_CMD="

if exist "%BUNDLED_EXE%" (
  "%BUNDLED_EXE%" unmask --config "%CONFIG_FILE%"
  set "EXIT_CODE=!ERRORLEVEL!"
  goto :finish
)

where py >nul 2>nul
if !ERRORLEVEL! EQU 0 (
  py -3 -c "import sys" >nul 2>nul
  if !ERRORLEVEL! EQU 0 set "PY_CMD=py -3"
)

if not defined PY_CMD (
  where python >nul 2>nul
  if !ERRORLEVEL! EQU 0 (
    python -c "import sys" >nul 2>nul
    if !ERRORLEVEL! EQU 0 set "PY_CMD=python"
  )
)

if not defined PY_CMD if exist "%LOCALAPPDATA%\anaconda3\python.exe" (
  "%LOCALAPPDATA%\anaconda3\python.exe" -c "import sys" >nul 2>nul
  if !ERRORLEVEL! EQU 0 set "PY_CMD="%LOCALAPPDATA%\anaconda3\python.exe""
)
if not defined PY_CMD if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" (
  "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" -c "import sys" >nul 2>nul
  if !ERRORLEVEL! EQU 0 set "PY_CMD="%LOCALAPPDATA%\Programs\Python\Python312\python.exe""
)
if not defined PY_CMD if exist "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" (
  "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" -c "import sys" >nul 2>nul
  if !ERRORLEVEL! EQU 0 set "PY_CMD="%LOCALAPPDATA%\Programs\Python\Python311\python.exe""
)

if not defined PY_CMD (
  powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Python runtime not found. Install Python 3.10+ and ensure py or python command is available.', 'Unmask Utility - Runtime Error', 'OK', 'Error') | Out-Null"
  set "EXIT_CODE=9009"
  goto :finish
)

call !PY_CMD! -m masking_utility.cli unmask --config "%CONFIG_FILE%"
set "EXIT_CODE=!ERRORLEVEL!"

:finish
if not defined EXIT_CODE set "EXIT_CODE=1"
if !EXIT_CODE! NEQ 0 (
  echo Unmask operation finished with error code !EXIT_CODE!.
) else (
  echo Unmask operation finished successfully.
)

if !EXIT_CODE! NEQ 0 (
  powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Unmask operation failed with error code !EXIT_CODE!. Check Logs\\masking_utility.log if available.', 'Unmask Utility - Error', 'OK', 'Error') | Out-Null"
)

endlocal & exit /b %EXIT_CODE%
