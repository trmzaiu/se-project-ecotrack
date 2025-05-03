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
        file_path = f"/tmp/{file.filename}"
        file.save(file_path)  # Save file temporarily

        print(f"Received file: {file.filename}, Size: {file.content_length} bytes")
        print(f"File saved at: {file_path}")

        # Correctly send image data to Hugging Face
        client = Client("wasteapp/EcoTrack")  # Replace with your Hugging Face Space ID
        result = client.predict(
            image=handle_file(file_path),  #Convert file to required format
            api_name="/predict"
        )

        return jsonify({"prediction": result})

    except Exception as e:
        print(f"Exception: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=10000, debug=True)
