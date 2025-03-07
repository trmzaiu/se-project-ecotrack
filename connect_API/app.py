import requests
from flask import Flask, request, jsonify
from gradio_client import Client, handle_file

app = Flask(__name__)

@app.route("/")
def home():
    return "Waste Classification API is running!"

@app.route("/classify", methods=["POST"])
def classify():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]
        file_content = file.read()
        if not file_content:
            return jsonify({"error": "Uploaded file is empty"}), 400

        print(f"✅ Received file: {file.filename}, Size: {len(file_content)} bytes")

        # Use Hugging Face Gradio API client
        client = Client("wasteapp/CLIP_classifier")  # Replace with your actual Hugging Face Space ID
        result = client.predict(handle_file(file.filename), api_name="/predict")

        return jsonify({"prediction": result})

    except Exception as e:
        print(f"⚠️ Exception: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
