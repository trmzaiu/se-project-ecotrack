import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # Allow up to 50MB uploads

@app.route("/")
def home():
    return "Waste Classification API is running!"

@app.route("/classify", methods=["POST"])
def classify():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]

        # Read file content before sending
        file_content = file.read()
        if not file_content:
            return jsonify({"error": "Uploaded file is empty"}), 400

        print(f"Received file: {file.filename}, Size: {len(file_content)} bytes")

        # Prepare the file payload
        files = {"file": (file.filename, file_content, file.mimetype)}

        HF_API_URL = "https://wasteapp-clip-classifier.hf.space/run/predict"
        response = requests.post(HF_API_URL, files=files, timeout=30)

        if response.status_code == 200:
            return jsonify(response.json())
        else:
            print(f"Hugging Face API Error: {response.text}")
            return jsonify({"error": f"Failed to classify image: {response.text}"}), 500

    except Exception as e:
        print(f"Exception: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
