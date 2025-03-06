import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

HF_API_URL = "https://wasteapp-clip-classifier.hf.space"

@app.route("/")
def home():
    return "Waste Classification API is running!"

@app.route("/classify", methods=["POST"])
def classify():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    files = {"file": (file.filename, file.stream, file.mimetype)}

    try:
        # Forward the request to Hugging Face API
        response = requests.post(HF_API_URL + "/api/predict", files=files)

        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify({"error": f"Failed to classify image. HF Status Code: {response.status_code}"}), 500

    except Exception as e:
        import traceback
        error_details = traceback.format_exc()  # Get full error details
        return jsonify({"error": "Internal Server Error", "details": error_details}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000)
