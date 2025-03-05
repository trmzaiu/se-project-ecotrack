import requests
from flask import Flask, request, jsonify

app = Flask(__name__)

# Hugging Face API URL (Replace with your real HF Space URL)
HF_API_URL = "https://huggingface.co/spaces/wasteapp/CLIP_classifier/predict"

@app.route("/predict", methods=["POST"])
def predict():
    try:
        # Receive image from Flutter app
        file = request.files["image"]
        files = {"file": (file.filename, file, file.content_type)}

        # Send image to Hugging Face API
        response = requests.post(HF_API_URL, files=files)
        return response.json()  # Return Hugging Face response
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(debug=True)
