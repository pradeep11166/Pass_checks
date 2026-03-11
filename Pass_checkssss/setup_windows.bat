@echo off
echo ======================================================
echo Sunderland CyberSecurity Project - Windows Setup
echo ======================================================

:: 1. Create Virtual Environment
echo Step 1: Creating Virtual Environment...
python -m venv venv

:: 2. Activate and Install Dependencies
echo Step 2: Installing Dependencies...
call venv\Scripts\activate
python -m pip install --upgrade pip
pip install -r requirements.txt

echo ======================================================
echo SETUP COMPLETE!
echo To start the system, run: python app.py
echo ======================================================
pause