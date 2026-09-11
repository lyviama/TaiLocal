@echo off
chcp 65001 >nul
echo ============================================
echo   TaiLocal one-click packaging
echo ============================================
echo.
where python >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Python not found. Install from python.org, check Add to PATH.
  pause
  exit /b 1
)
echo [1/2] Installing pyinstaller ...
python -m pip install pyinstaller -q
if errorlevel 1 (
  echo [ERROR] pip install failed.
  pause
  exit /b 1
)
echo [2/2] Building TaiLocal.exe ... (1-3 minutes)
python -m PyInstaller --onefile --noconsole --name TaiLocal --collect-all opencc --add-data "terms.csv;." --add-data "post_fix.csv;." tailocal.py
if errorlevel 1 (
  echo [ERROR] Build failed. Screenshot this window.
  pause
  exit /b 1
)
echo.
echo DONE! Software is at:  dist\TaiLocal.exe
echo Terms database is built in. No extra files needed.
pause
