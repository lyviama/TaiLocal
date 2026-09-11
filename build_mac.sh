#!/bin/bash
# TaiLocal Mac 一键打包 → dist/TaiLocal
set -e
python3 -m pip install pyinstaller pandas openpyxl opencc-python-reimplemented -q
python3 -m PyInstaller --onefile --windowed --name TaiLocal --collect-all opencc --add-data "terms.csv:." --add-data "post_fix.csv:." tailocal.py
echo "打包完成！软件在 dist/TaiLocal"
