from flask import Request, jsonify
import logging
from datetime import datetime


def update_data(request: Request):
    """
    Cloud Function to handle PUT requests and update data.

    Args:
        request (flask.Request): The HTTP request object.

    Returns:
        Response: JSON response with status message or error.
    """
    try:
        if request.method != 'PUT':
            return jsonify({
                "error": "Method Not Allowed. Use PUT.",
                "status_code": 405,
                "timestamp": datetime.utcnow().isoformat()
            }), 405

        try:
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

        # Return updated data along with status code and timestamp
        return jsonify({
            "updated_data": updated_data,
            "status_code": 200,
            "timestamp": datetime.utcnow().isoformat()
        }), 200

    except Exception as e:
        logging.exception("An unexpected error occurred")
        return jsonify({
            "error": f"Internal Server Error: {str(e)}",
            "status_code": 500,
            "timestamp": datetime.utcnow().isoformat()
        }), 500
