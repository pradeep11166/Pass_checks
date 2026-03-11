#!/bin/bash

echo "--- Starting Setup for Pass_check ---"

# 1. Remove any old, broken environments
rm -rf venv

# 2. Create a new venv using the stable Python 3.13
echo "Creating Virtual Environment with Python 3.13..."
python3.13 -m venv venv

# 3. Activate the environment
source venv/bin/activate

# 4. Upgrade pip and install requirements
echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "--- Setup Complete ---"
echo "To start your Flask app, run: source venv/bin/activate && python app.py"