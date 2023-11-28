@echo off
where python >nul 2>nul || (
    echo Python not found. Please install Python and add it to your PATH.
    exit /b 1
)

python -m pip install --upgrade pip
pip install -i https://secured.example.com/artifactory/ --trusted-host secured.example.com -r requirements.txt --user --no-warn-script-location
