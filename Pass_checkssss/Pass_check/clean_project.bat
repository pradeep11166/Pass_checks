@echo off
echo ======================================================
echo Cleaning Project for Export (Windows)
echo ======================================================

:: 1. Remove the SQLite Database
if exist users.db (
    del users.db
    echo [OK] users.db removed.
)

:: 2. Remove Virtual Environment
if exist venv (
    rd /s /q venv
    echo [OK] venv folder removed.
)

:: 3. Remove Python Cache
for /d /r . %%d in (__pycache__) do @if exist "%%d" (
    rd /s /q "%%d"
    echo [OK] Removed %%d
)

echo ======================================================
echo Project is now CLEAN and ready to be zipped.
echo ======================================================
pause