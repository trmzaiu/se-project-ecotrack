import requests
from flask import Flask, request, jsonify
from gradio_client import Client
import os

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

        # Save file temporarily in the server
        temp_filepath = f"/tmp/{file.filename}"
        file.save(temp_filepath)

        print(f"Received file: {file.filename}, Size: {os.path.getsize(temp_filepath)} bytes")
        print(f"File saved at: {temp_filepath}")

        # Use Hugging Face Gradio API client
        client = Client("wasteapp/CLIP_classifier")  # Replace with your actual Hugging Face Space ID
        result = client.predict(temp_filepath, api_name="/predict")

        # Delete the temporary file after processing
        os.remove(temp_filepath)

        return jsonify({"prediction": result})

    except Exception as e:
        print(f"Exception: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
