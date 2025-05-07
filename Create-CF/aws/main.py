from flask import Request, jsonify
import logging

def update_data(request: Request):
    """
    Cloud Function to handle PUT requests and update data.

    Args:
        request (flask.Request): The HTTP request object.

    Returns:
        Response: JSON response with status message or error.
    """
    if request.method != 'PUT':
        return jsonify({"error": "Method Not Allowed. Use PUT."}), 405

    try:
        data = request.get_json(force=True)
        if not isinstance(data, dict):
            raise ValueError("JSON payload must be an object")
    except Exception as e:
        logging.exception("Failed to parse JSON payload")
        return jsonify({"error": f"Invalid JSON: {str(e)}"}), 400

    # Simulate updating the data
    updated_data = {**data, "status": "updated"}

    return jsonify(updated_data), 200
