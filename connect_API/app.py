import requests
import time
from flask import Flask, request, jsonify

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB upload limit

HF_API_URL = "https://wasteapp-clip-classifier.hf.space/predict"

@app.route("/classify", methods=["POST"])
def classify():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]

        # Read file contents in binary mode
        file_bytes = file.read()

        # Step 1: Send file to Hugging Face API
        files = {"data": ("file", file_bytes, file.mimetype)}
        response = requests.post(HF_API_URL, files=files, timeout=30)

        if response.status_code != 200:
            return jsonify({"error": f"Failed to classify image: {response.text}"}), 500

        # Check if the response is valid JSON
        try:
            response_json = response.json()
        except ValueError:
            return jsonify({"error": "Invalid response from API, not JSON"}), 500

        # Step 2: Extract classification result (Modify this based on HF API output)
        if "data" in response_json:
            return jsonify({"result": response_json["data"]})

        return jsonify({"error": "Unexpected API response format"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
