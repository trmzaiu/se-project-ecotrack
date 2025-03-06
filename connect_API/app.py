from flask import Flask, request, jsonify
import requests
import logging
import os

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Get Hugging Face API URL from environment variable or use default
HUGGINGFACE_API_URL = os.environ.get('HUGGINGFACE_API_URL', 'https://wasteapp-clip-classifier.hf.space')

@app.route('/health', methods=['GET'])
def health_check():
    """Simple endpoint to check if the API is running"""
    try:
        # Check if Hugging Face API is accessible
        response = requests.get(HUGGINGFACE_API_URL.replace('/api/classify', '/health'), timeout=5)
        hf_status = response.status_code == 200
    except:
        hf_status = False

    return jsonify({
        "status": "healthy",
        "huggingface_connected": hf_status
    })

@app.route('/classify', methods=['POST'])
def classify_image():
    """Endpoint to forward requests to Hugging Face CLIP model"""
    try:
        # Check if image file exists in request
        if 'image' not in request.files:
            logger.warning("No image file in request")
            return jsonify({"error": "No image file provided"}), 400

        image_file = request.files['image']
        logger.info(f"Received image: {image_file.filename}, forwarding to Hugging Face")

        # Forward the file to Hugging Face API
        files = {'file': (image_file.filename, image_file.read(), image_file.content_type)}

        response = requests.post(
            HUGGINGFACE_API_URL,
            files=files,
            timeout=30  # Increased timeout for model inference
        )

        # Check if the request was successful
        if response.status_code == 200:
            logger.info("Successfully received classification from Hugging Face")
            return response.json()
        else:
            logger.error(f"Hugging Face API error: {response.status_code} - {response.text}")
            return jsonify({
                "error": f"Error from Hugging Face API: {response.status_code}",
                "details": response.text
            }), 500

    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 10000))
    app.run(host='0.0.0.0', port=port)