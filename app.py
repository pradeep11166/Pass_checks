import os
from flask import Flask, render_template, request, make_response, jsonify
from flask_sqlalchemy import SQLAlchemy
from argon2 import PasswordHasher
from markupsafe import escape
from captcha_utils import generate_captcha_image, validate_captcha

app = Flask(__name__)
# Static key ensures sessions persist during development reloads
app.config['SECRET_KEY'] = 'sunderland_cyber_secure_project_2026' 
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///users.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
ph = PasswordHasher() # Implementing Argon2id [cite: 40]

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    password_hash = db.Column(db.String(200), nullable=False)

def check_password_strength(password):
    """Algorithm to quantify security level and provide feedback."""
    if len(password) < 8:
        return 0, ["at least 8 characters (REQUIRED)"]
    
    score = 1
    tips = []
    if len(password) >= 12: score += 1
    else: tips.append("use atleast 8 characters")
    
    if not any(c.isupper() for c in password): tips.append("uppercase")
    else: score += 1
    if not any(c.islower() for c in password): tips.append("lowercase")
    else: score += 1
    if not any(c.isdigit() for c in password): tips.append("numbers")
    else: score += 1
    if not any(c in "#@$%!^&*" for c in password): tips.append("symbols (#@$%!^&*)")
    else: score += 1
    
    return score, tips

@app.route('/captcha')
def captcha_route():
    resp = make_response(generate_captcha_image())
    # Headers to prevent browser caching
    resp.headers['Cache-Control'] = 'no-store, no-cache, must-revalidate, max-age=0'
    return resp

@app.route('/check-captcha', methods=['POST'])
def check_captcha_realtime():
    """Endpoint for real-time frontend validation."""
    data = request.get_json()
    user_input = data.get('captcha', '')
    is_valid = validate_captcha(user_input)
    return jsonify({"valid": is_valid})

@app.route('/', methods=['GET', 'POST'])
def register():
    message = ""
    status_class = "error"
    
    if request.method == 'POST':
        username = escape(request.form.get('username', '').strip())
        password = request.form.get('password', '')
        captcha_input = request.form.get('captcha', '')

        if not validate_captcha(captcha_input):
            message = "Validation Error: Incorrect or Expired CAPTCHA."
        else:
            score, suggestions = check_password_strength(password)
            if score < 1:
                message = "Critical Error: Password too short (Min 8)."
            elif score < 5:
                message = "Moderate Strength. Tips: Add " + ", ".join(suggestions)
            else:
                try:
                    hashed_pw = ph.hash(password) # Secure Hashing [cite: 40]
                    new_user = User(username=username, password_hash=hashed_pw)
                    db.session.add(new_user)
                    db.session.commit()
                    message = "Success: User registered securely."
                    status_class = "success"
                except:
                    message = "Error: Username already exists."
                    
    return render_template('register.html', message=message, status_class=status_class)

if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    # Port 5001 avoids macOS conflicts
    app.run(debug=True, port=5001)