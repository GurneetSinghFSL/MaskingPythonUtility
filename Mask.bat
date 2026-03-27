@echo off
setlocal
set SCRIPT_DIR=%~dp0
python -m masking_utility.cli mask --config "%SCRIPT_DIR%utility-config.json"
set EXIT_CODE=%ERRORLEVEL%
if %EXIT_CODE% neq 0 (
  echo Mask operation finished with error code %EXIT_CODE%.
) else (
  echo Mask operation finished successfully.
)
endlocal
exit /b %EXIT_CODE%
