from flask import Flask, request, jsonify


def update_data(request):
    """
    HTTP Cloud Function to handle PUT requests.
    """
    if request.method != 'PUT':
        return jsonify({"error": "Only PUT requests are allowed"}), 405

    try:
        data = request.get_json()
        if not data:
            raise ValueError("No JSON payload found")
    except Exception as e:
        return jsonify({"error": f"Invalid request: {e}"}), 400

    updated_data = {**data, "status": "updated"}
    return jsonify(updated_data), 200
