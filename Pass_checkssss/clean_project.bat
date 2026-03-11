@echo off
setlocal
echo ======================================================
echo Sunderland CyberSecurity: Deep Clean for Export
echo ======================================================

:: 1. Kill any running Python/Flask processes to unlock files
echo Step 1: Terminating active Python processes...
taskkill /F /IM python.exe /T >nul 2>&1
taskkill /F /IM flask.exe /T >nul 2>&1

:: 2. Remove the SQLite Database (Sanitize User Data)
echo Step 2: Removing local databases...
if exist "users.db" (
    del /f /q "users.db"
    echo [OK] users.db removed.
)

:: 3. Remove Virtual Environments
echo Step 3: Removing Virtual Environments...
if exist "venv" (
    rd /s /q "venv"
    echo [OK] venv folder removed.
)
if exist ".venv" (
    rd /s /q ".venv"
    echo [OK] .venv folder removed.
)

:: 4. Remove Python Cache & Bytecode
echo Step 4: Purging Python bytecode cache...
for /d /r . %%d in (__pycache__) do @if exist "%%d" (
    rd /s /q "%%d"
)
del /s /q *.pyc *.pyo >nul 2>&1

:: 5. Remove IDE Metadata (Keeps project "Intact" but "Clean")
echo Step 5: Removing IDE metadata (.vscode, .idea)...
if exist ".vscode" rd /s /q ".vscode"
if exist ".idea" rd /s /q ".idea"

echo ======================================================
echo STATUS: CLEANED AND READY FOR ZIP
echo Intact: app.py, captcha_utils.py, templates, requirements.txt
echo ======================================================
pause