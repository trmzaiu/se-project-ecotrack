from flask import Flask, request, jsonify
from flask_cors import CORS
import torch
import clip
from PIL import Image
import io
model = None

app = Flask(__name__)
CORS(app)

# Load CLIP model
device = "cuda" if torch.cuda.is_available() else "cpu"
def load_model():
    global model
    if model is None:
        model, preprocess = clip.load("ViT-B/32", device=device)

# Define waste categories
categories = ["Organic", "Recyclables", "General Waste", "Hazardous"]

@app.route("/classify", methods=["POST"])
def classify():
    if "file" not in request.files:
        return jsonify({"error": "No file uploaded"}), 400

    file = request.files["file"]
    image = Image.open(io.BytesIO(file.read()))

    # Preprocess and encode image
    image_input = preprocess(image).unsqueeze(0).to(device)
    with torch.no_grad():
        image_features = model.encode_image(image_input)

    # Encode text labels
    text_inputs = clip.tokenize(categories).to(device)
    with torch.no_grad():
        text_features = model.encode_text(text_inputs)

    # Compute similarity
    similarity = (image_features @ text_features.T).softmax(dim=-1)
    best_match = categories[similarity.argmax().item()]

    return jsonify({"category": best_match})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
