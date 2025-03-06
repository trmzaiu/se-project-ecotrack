import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# Hugging Face API URL
HF_API_URL = "https://wasteapp-clip-classifier.hf.space/predict"

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
        # Debugging: Print when request is sent
        print(f"Forwarding image {file.filename} to Hugging Face API...")

        response = requests.post(HF_API_URL, files=files)

        # Debugging: Print Hugging Face response
        print(f"Hugging Face Response: {response.status_code} - {response.text}")

        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify({"error": "Failed to classify image", "status_code": response.status_code}), 500

    except Exception as e:
        print(f"Error occurred: {str(e)}")
        return jsonify({"error": f"Internal Server Error: {str(e)}"}), 500

if __name__ == "__main__":
    app.run
