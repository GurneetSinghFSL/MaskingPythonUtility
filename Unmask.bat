@echo off
setlocal
set SCRIPT_DIR=%~dp0
set BUNDLED_EXE=%SCRIPT_DIR%bin\MaskingUtility.exe

if exist "%BUNDLED_EXE%" (
  "%BUNDLED_EXE%" unmask --config "%SCRIPT_DIR%utility-config.json"
  set EXIT_CODE=%ERRORLEVEL%
  if %EXIT_CODE% neq 0 (
    echo Unmask operation finished with error code %EXIT_CODE%.
  ) else (
    echo Unmask operation finished successfully.
  )
  endlocal
  exit /b %EXIT_CODE%
)

set PY_CMD=
where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  set PY_CMD=py -3
) else (
  where python >nul 2>nul
  if %ERRORLEVEL% EQU 0 set PY_CMD=python
)

if "%PY_CMD%"=="" (
  if exist "%LOCALAPPDATA%\anaconda3\python.exe" set PY_CMD="%LOCALAPPDATA%\anaconda3\python.exe"
)
if "%PY_CMD%"=="" (
  if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" set PY_CMD="%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
)
if "%PY_CMD%"=="" (
  if exist "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" set PY_CMD="%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
)

if "%PY_CMD%"=="" (
  powershell -NoProfile -Command "Add-Type -AssemblyName PresentationFramework; [System.Windows.MessageBox]::Show('Python runtime not found. Install Python 3.10+ and ensure ''py'' or ''python'' command is available.', 'Unmask Utility - Runtime Error', 'OK', 'Error') | Out-Null"
  exit /b 9009
)

%PY_CMD% -m masking_utility.cli unmask --config "%SCRIPT_DIR%utility-config.json"
set EXIT_CODE=%ERRORLEVEL%
if %EXIT_CODE% neq 0 (
  echo Unmask operation finished with error code %EXIT_CODE%.
) else (
  echo Unmask operation finished successfully.
)
endlocal
exit /b %EXIT_CODE%
