from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

# Increase max upload size (e.g., 50MB)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024

@app.route("/")
def home():
    return "Waste Classification API is running!"

@app.route("/classify", methods=["POST"])
def classify():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]

        # Read file fully into memory before sending
        file_content = file.read()

        files = {"file": (file.filename, file_content, file.mimetype)}

        HF_API_URL = "https://wasteapp-clip-classifier.hf.space/run/predict"
        response = requests.post(HF_API_URL, files=files, timeout=30)

        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify({"error": f"Failed to classify image: {response.text}"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
