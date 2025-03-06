import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://huggingface.co/spaces/wasteapp/CLIP_classifier/predict";

  static Future<String?> classifyImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('data', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);

        // Adjust the response format to match Gradio
        if (jsonResponse["data"] != null && jsonResponse["data"].isNotEmpty) {
          return jsonResponse["data"][0];  // Gradio returns results in a list
        } else {
          return "Error: No prediction received";
        }
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      return "Error: $e";
    }
  }
}
