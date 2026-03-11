#!/bin/bash
cd "$(dirname "$0")"

echo "--- Sunderland CyberSecurity Setup (macOS) ---"

# 1. Create Environment
python3 -m venv venv
source venv/bin/activate

# 2. CRITICAL: Upgrade build tools first
pip install --upgrade pip setuptools wheel

# 3. Force Binary Installation for Pillow (Fixes Python 3.14 error)
echo "Installing Pillow Binary..."
pip install Pillow==10.4.0 --only-binary=:all:

# 4. Install remaining requirements
echo "Installing other dependencies..."
pip install -r requirements.txt

echo "----------------------------------------------"
echo "SETUP COMPLETE. Environment is ACTIVE."
echo "----------------------------------------------"

exec bash --rcfile <(echo "source venv/bin/activate")