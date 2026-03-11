import os
import sys
import subprocess
import platform

def run_command(command):
    """Executes a system command and handles errors."""
    try:
        subprocess.check_call(command, shell=True)
    except subprocess.CalledProcessError as e:
        print(f"Error executing command: {command}")
        sys.exit(1)

def setup():
    print("--- University of Sunderland: CET324 Project Setup ---")
    print(f"Detected OS: {platform.system()} {platform.release()}")

    # 1. Create Virtual Environment
    print("\nStep 1: Creating Virtual Environment...")
    if not os.path.exists("venv"):
        run_command(f"{sys.executable} -m venv venv")
    else:
        print("Virtual environment already exists.")

    # 2. Determine the path to the venv python executable
    if platform.system() == "Windows":
        python_path = os.path.join("venv", "Scripts", "python.exe")
        pip_path = os.path.join("venv", "Scripts", "pip.exe")
    else:
        python_path = os.path.join("venv", "bin", "python")
        pip_path = os.path.join("venv", "bin", "pip")

    # 3. Upgrade Pip and Install Dependencies
    print("\nStep 2: Installing Dependencies from requirements.txt...")
    run_command(f"{python_path} -m pip install --upgrade pip")
    
    # Check if requirements.txt exists
    if os.path.exists("requirements.txt"):
        run_command(f"{python_path} -m pip install -r requirements.txt")
    else:
        # Fallback installation if file is missing
        print("requirements.txt not found! Installing default packages...")
        run_command(f"{python_path} -m pip install flask flask-sqlalchemy argon2-cffi captcha Pillow")

    print("\n" + "="*50)
    print("SETUP SUCCESSFUL!")
    print(f"To run the application, use the following command:")
    if platform.system() == "Windows":
        print(f"   venv\\Scripts\\python app.py")
    else:
        print(f"   ./venv/bin/python app.py")
    print("="*50)

if __name__ == "__main__":
    setup()