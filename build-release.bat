@echo off
setlocal
set PYTHONPATH=
set SCRIPT_DIR=%~dp0
set RELEASE_DIR=%SCRIPT_DIR%release
set BUILD_DIR=%SCRIPT_DIR%build
set DIST_DIR=%SCRIPT_DIR%dist
set BUILD_VENV=%SCRIPT_DIR%.build-venv
set EXE_NAME=MaskingUtility.exe
set SOURCE_PY=
set BUILD_PY=

echo Resolving base Python runtime...
where py >nul 2>nul
if %ERRORLEVEL% EQU 0 (
  set SOURCE_PY=py -3
) else (
  where python >nul 2>nul
  if %ERRORLEVEL% EQU 0 (
    set SOURCE_PY=python
  )
)

if "%SOURCE_PY%"=="" (
  if exist "%LOCALAPPDATA%\anaconda3\python.exe" set SOURCE_PY="%LOCALAPPDATA%\anaconda3\python.exe"
)
if "%SOURCE_PY%"=="" (
  if exist "%LOCALAPPDATA%\Programs\Python\Python312\python.exe" set SOURCE_PY="%LOCALAPPDATA%\Programs\Python\Python312\python.exe"
)
if "%SOURCE_PY%"=="" (
  if exist "%LOCALAPPDATA%\Programs\Python\Python311\python.exe" set SOURCE_PY="%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
)

if "%SOURCE_PY%"=="" (
  echo Python runtime not found. Install Python 3.10+ to build release.
  exit /b 9009
)

echo Preparing isolated build virtual environment...
if exist "%BUILD_VENV%" (
  rmdir /s /q "%BUILD_VENV%"
)
if exist "%BUILD_VENV%" (
  set BUILD_VENV=%SCRIPT_DIR%.build-venv-%RANDOM%
)
if not "%BUILD_VENV%"=="%SCRIPT_DIR%.build-venv" echo Existing .build-venv is locked. Using %BUILD_VENV% for this build.
%SOURCE_PY% -m venv "%BUILD_VENV%"
if %ERRORLEVEL% neq 0 (
  echo Failed to create build virtual environment.
  exit /b %ERRORLEVEL%
)

set BUILD_PY=%BUILD_VENV%\Scripts\python.exe

"%BUILD_PY%" -m ensurepip --upgrade
if %ERRORLEVEL% neq 0 (
  echo Failed to bootstrap pip in build virtual environment.
  exit /b %ERRORLEVEL%
)

echo Installing build dependencies into isolated environment...
"%BUILD_PY%" -m pip install --upgrade pip
if %ERRORLEVEL% neq 0 (
  echo Failed to upgrade pip in build virtual environment.
  exit /b %ERRORLEVEL%
)

"%BUILD_PY%" -m pip install --upgrade pyinstaller -r "%SCRIPT_DIR%requirements.txt"
if %ERRORLEVEL% neq 0 (
  echo Failed to install build dependencies in build virtual environment.
  exit /b %ERRORLEVEL%
)

echo Cleaning old build artifacts...
if exist "%BUILD_DIR%" rmdir /s /q "%BUILD_DIR%"
if exist "%DIST_DIR%" rmdir /s /q "%DIST_DIR%"
if exist "%RELEASE_DIR%" rmdir /s /q "%RELEASE_DIR%"

echo Building bundled executable...
echo This step can take several minutes on first run.
"%BUILD_PY%" -m PyInstaller --noconfirm --clean --onefile --name MaskingUtility "%SCRIPT_DIR%run_utility.py"
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
