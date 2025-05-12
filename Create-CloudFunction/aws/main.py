import base64
import io
import json
from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

# Set up logging
import logging

logging.basicConfig(level=logging.INFO)


@app.route("/", methods=["PUT"])
def update_data():
    try:
        # Parse JSON payload from the request
        data = request.get_json(force=True)
        if not isinstance(data, dict):
            raise ValueError("JSON payload must be an object")
    except Exception as e:
        logging.exception("Failed to parse JSON payload")
        return jsonify({
            "error": f"Invalid JSON: {str(e)}",
            "status_code": 400,
            "timestamp": datetime.utcnow().isoformat()
        }), 400

    # Simulate updating the data
    updated_data = {**data, "status": "updated"}

    return jsonify({
        "updated_data": updated_data,
        "status_code": 200,
        "timestamp": datetime.utcnow().isoformat()
    }), 200


@app.errorhandler(405)
def method_not_allowed(e):
    return jsonify({
        "error": "Method Not Allowed. Use PUT.",
        "status_code": 405,
        "timestamp": datetime.utcnow().isoformat()
    }), 405


def lambda_handler(event, context):
    """
    Lambda function handler that uses Flask.
    """
    print(json.dumps(event))  # Log the event in a single line

    # Extract headers and body from the Lambda event
    headers = event.get('headers', {})
    body = event.get('body', '')

    # Check if the body is empty
    if not body:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': 'Empty body provided.',
                'status_code': 400,
                'timestamp': datetime.utcnow().isoformat()
            })
        }

    # If the body is not base64-encoded, parse it directly as JSON
    if not event.get('isBase64Encoded', False):
        try:
            parsed_body = json.loads(body)  # Parse the JSON string

        except json.JSONDecodeError as e:
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'error': f'{str(e)}',
                    'status_code': 400,
                    'timestamp': datetime.utcnow().isoformat()
                })
            }
    else:
        # If base64 is encoded, we would need to decode it (though it's `False` in this case)
        body = json.loads(base64.b64decode(body).decode('utf-8'))
        parsed_body = body  # Assign decoded body to parsed_body

    # ... inside lambda_handler, after parsing `parsed_body`
    body_bytes = json.dumps(parsed_body).encode('utf-8')  # Convert dict to JSON string, then bytes

    # Log the parsed body for debugging
    print(f"Parsed body: {body_bytes}")

    environ = {
        'REQUEST_METHOD': 'PUT',
        'PATH_INFO': '/',
        'CONTENT_TYPE': headers.get('Content-Type', 'application/json'),
        'wsgi.url_scheme': 'https',
        'wsgi.input': io.BytesIO(body_bytes),  # ✅ Correct way to pass request body
        'CONTENT_LENGTH': str(len(body_bytes)),  # 🔍 Required by Flask to read input
        'SERVER_NAME': 'localhost',
        'SERVER_PORT': '80',
        'HTTP_HOST': headers.get('Host', 'localhost'),
    }

    # Create a Flask request context and process the request
    with app.request_context(environ):
        response = app.full_dispatch_request()

    # Return the response in the format expected by API Gateway
    return {
        'statusCode': response.status_code,
        'body': response.get_data(as_text=True),
        'headers': dict(response.headers)
    }
