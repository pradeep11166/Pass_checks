#!/bin/bash

echo "======================================================"
echo "Sunderland CyberSecurity: Deep Clean for Export"
echo "======================================================"

# 1. Kill any active Flask/Python processes (Prevents 'File in Use' errors)
echo "Step 1: Terminating active Python processes..."
pkill -f "python3 app.py" > /dev/null 2>&1
pkill -f "flask" > /dev/null 2>&1

# 2. Remove the SQLite Database (Sanitize test data)
echo "Step 2: Removing local databases..."
if [ -f "users.db" ]; then
    rm -f users.db
    echo "[OK] users.db removed."
fi

# 3. Remove Virtual Environments
echo "Step 3: Removing Virtual Environments..."
if [ -d "venv" ]; then
    rm -rf venv
    echo "[OK] venv folder removed."
fi
if [ -d ".venv" ]; then
    rm -rf .venv
    echo "[OK] .venv folder removed."
fi

# 4. Remove Python Cache and hidden system files
echo "Step 4: Purging Python bytecode and OS metadata..."
find . -type d -name "__pycache__" -exec rm -rf {} +
find . -type f -name "*.pyc" -delete
find . -type f -name "*.pyo" -delete
find . -type f -name ".DS_Store" -delete

# 5. Remove IDE Metadata (Keeps project 'Intact' but 'Clean')
echo "Step 5: Removing IDE metadata (.vscode, .idea)..."
rm -rf .vscode .idea

echo "======================================================"
echo "STATUS: CLEANED AND READY FOR ZIP"
echo "Intact: app.py, captcha_utils.py, templates, requirements.txt"
echo "======================================================"