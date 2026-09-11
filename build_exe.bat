@echo off
chcp 65001 >nul
echo ============================================
echo   TaiLocal one-click packaging
echo ============================================
echo.

where python >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Python not found.
  echo Please install Python from https://www.python.org/downloads/
  echo IMPORTANT: check "Add Python to PATH" during install.
  echo.
  pause
  exit /b 1
)

echo [1/2] Installing pyinstaller ...
python -m pip install pyinstaller -q
if errorlevel 1 (
  echo [ERROR] pip install failed. Check internet and try again.
  pause
  exit /b 1
)

echo [2/2] Building TaiLocal.exe ...
python -m PyInstaller --onefile --noconsole --name TaiLocal tailocal.py
if errorlevel 1 (
  echo [ERROR] Build failed. Screenshot this window and send it.
  pause
  exit /b 1
)

echo.
echo ============================================
echo   DONE! Software is at:  dist\TaiLocal.exe
echo ============================================
pause
