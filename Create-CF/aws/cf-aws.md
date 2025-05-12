# ---------- Install Dependencies ----------
# Install all required packages listed in requirements.txt
pip install -r requirements.txt


# ---------- Package Function for AWS Lambda (or similar) ----------
# Create a zip archive named 'function.zip' containing 'main.py'
zip function.zip main.py


# ---------- Create a Flask Layer (for AWS Lambda layers or similar use) ----------
# Make a directory named 'python' (AWS Lambda requires this structure for layers)
mkdir -p python

# Install Flask into the 'python' directory (layer structure)
pip install flask -t python/

# Reinstall Flask and Werkzeug into the same directory (Werkzeug is a Flask dependency)
# Note: The repeated `flask` install is redundant but doesn't harm
pip install flask werkzeug -t python/

# Zip the 'python' directory into 'flask_layer.zip' for use as a Lambda layer
zip -r flask_layer.zip python


# ---------- Test API Call ----------
# Send a PUT request with JSON data to a specified API endpoint
# Useful for testing endpoints with example payloads
curl -X PUT -H "Content-Type: application/json" \
-d '{"id": 123345543, "name": "Test-account"}' \
https://your-api-url
