from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

HUGGING_FACE_API = "https://huggingface.co/spaces/wasteapp/CLIP_classifier/predict"  # Replace with your actual API

@app.route("/classify", methods=["POST"])
def classify():
    try:
        image = request.files["image"]
        files = {"file": (image.filename, image.read(), image.content_type)}
        response = requests.post(HUGGING_FACE_API, files=files)
        return response.json()
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route("/", methods=["GET"])
def home():
    return "Flask API is running!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
