@echo off
setlocal
set SCRIPT_DIR=%~dp0
set RELEASE_DIR=%SCRIPT_DIR%release
set BUILD_DIR=%SCRIPT_DIR%build
set DIST_DIR=%SCRIPT_DIR%dist
set EXE_NAME=MaskingUtility.exe

where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  set PY_CMD=py -3
) else (
  where python >nul 2>nul
  if %ERRORLEVEL% EQU 0 (
    set PY_CMD=python
  )
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
  echo Python runtime not found. Install Python 3.10+ to build release.
  exit /b 9009
)

echo Installing/updating build dependencies...
%PY_CMD% -m pip install --upgrade pip pyinstaller >nul
if %ERRORLEVEL% neq 0 (
  echo Failed to install build dependencies.
  exit /b %ERRORLEVEL%
)

echo Cleaning old build artifacts...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
if exist "%RELEASE_DIR%" rmdir /s /q "%RELEASE_DIR%"

echo Building bundled executable...
%PY_CMD% -m PyInstaller --noconfirm --clean --onefile --name MaskingUtility "%SCRIPT_DIR%run_utility.py"
if %ERRORLEVEL% neq 0 (
  echo Build failed.
  exit /b %ERRORLEVEL%
)

echo Creating release folder structure...
mkdir "%RELEASE_DIR%\bin" >nul 2>nul
mkdir "%RELEASE_DIR%\Input" >nul 2>nul
mkdir "%RELEASE_DIR%\Logs" >nul 2>nul
mkdir "%RELEASE_DIR%\Output\Masked" >nul 2>nul
mkdir "%RELEASE_DIR%\Output\Unmasked" >nul 2>nul

copy /Y "%DIST_DIR%\%EXE_NAME%" "%RELEASE_DIR%\bin\%EXE_NAME%" >nul
copy /Y "%SCRIPT_DIR%Mask.bat" "%RELEASE_DIR%\Mask.bat" >nul
copy /Y "%SCRIPT_DIR%Unmask.bat" "%RELEASE_DIR%\Unmask.bat" >nul
copy /Y "%SCRIPT_DIR%utility-config.json" "%RELEASE_DIR%\utility-config.json" >nul
copy /Y "%SCRIPT_DIR%Masking.xlsx" "%RELEASE_DIR%\Masking.xlsx" >nul
copy /Y "%SCRIPT_DIR%README.md" "%RELEASE_DIR%\README.md" >nul
copy /Y "%SCRIPT_DIR%USER_GUIDE.md" "%RELEASE_DIR%\USER_GUIDE.md" >nul

echo Release build complete.
echo Output: %RELEASE_DIR%
endlocal
exit /b 0
