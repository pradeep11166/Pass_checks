import random
import string
import time
from flask import session, send_file
from captcha.image import ImageCaptcha

def generate_captcha_image():
    """Generates a professional CAPTCHA and timestamps it for security."""
    # Use unambiguous characters for better user experience
    chars = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"
    text = ''.join(random.choices(chars, k=5))
    
    session['captcha_text'] = text
    session['captcha_time'] = time.time()
    
    # Professional distortion to prevent OCR bypass
    generator = ImageCaptcha(width=160, height=60)
    data = generator.generate(text)
    return send_file(data, mimetype='image/png')

def validate_captcha(user_input):
    """Sanitizes and validates input with a strict session check."""
    if not user_input:
        return False
        
    stored_text = session.get('captcha_text', '')
    # Sanitization: Force uppercase and remove all whitespace
    clean_input = str(user_input).replace(" ", "").upper()
    
    # Check if correct and not expired (2-minute window)
    is_valid = (clean_input == stored_text) and (stored_text != "")
    
    return is_valid