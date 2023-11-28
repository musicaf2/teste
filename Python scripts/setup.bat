@echo off
where python >nul 2>nul || (
    echo Python not found. Please install Python and add it to your PATH.
    exit /b 1
)

python -m pip install --upgrade pip
python -m pip install -r requirements.txt --user --no-warn-script-location
