@echo off
echo --- Starting Setup for Pass_check (Windows) ---

:: 1. Remove old, broken environment if it exists
if exist venv (
    echo Removing old virtual environment...
    rmdir /s /q venv
)

:: 2. Create a new venv
echo Creating Virtual Environment...
python -m venv venv

:: 3. Activate the environment
echo Activating Environment...
call venv\Scripts\activate

:: 4. Upgrade pip and install requirements
echo Installing dependencies...
python -m pip install --upgrade pip
pip install -r requirements.txt

echo --- Setup Complete ---
echo To start your Flask app, run: venv\Scripts\activate ^&^& python app.py
pause