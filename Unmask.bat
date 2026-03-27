@echo off
setlocal
set SCRIPT_DIR=%~dp0
python -m masking_utility.cli unmask --config "%SCRIPT_DIR%utility-config.json"
set EXIT_CODE=%ERRORLEVEL%
if %EXIT_CODE% neq 0 (
  echo Unmask operation finished with error code %EXIT_CODE%.
) else (
  echo Unmask operation finished successfully.
)
endlocal
exit /b %EXIT_CODE%
