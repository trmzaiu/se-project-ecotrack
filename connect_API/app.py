import requests
from flask import Flask, request, jsonify

app = Flask(__name__)
app.config['MAX_CONTENT_LENGTH'] = 50 * 1024 * 1024  # 50MB upload limit

HF_API_URL = "https://wasteapp-clip-classifier.hf.space/gradio_api/call/predict"

@app.route("/classify", methods=["POST"])
def classify():
    try:
        if "file" not in request.files:
            return jsonify({"error": "No file uploaded"}), 400

        file = request.files["file"]
        files = {"file": (file.filename, file.read(), file.mimetype)}

        # Step 1: Send file to Hugging Face API
        response = requests.post(HF_API_URL, files=files, timeout=30)

        if response.status_code != 200:
            return jsonify({"error": f"Failed to classify image: {response.text}"}), 500

        event_id = response.json().get("event_id")
        if not event_id:
            return jsonify({"error": "Missing event_id from Hugging Face API"}), 500

        # Step 2: Fetch the prediction result using event_id
        result_url = f"https://wasteapp-clip-classifier.hf.space/gradio_api/call/predict/{event_id}"
        result_response = requests.get(result_url, timeout=30)

        if result_response.status_code == 200:
            return jsonify(result_response.json())
        else:
            return jsonify({"error": f"Failed to fetch classification result: {result_response.text}"}), 500

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
