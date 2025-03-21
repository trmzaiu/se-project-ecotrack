import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:http/http.dart' as http;

class CloudinaryConfig {
  // Singleton instance
  static final CloudinaryConfig _instance = CloudinaryConfig._internal();

  // Factory constructor
  factory CloudinaryConfig() {
    return _instance;
  }

  // Private constructor
  CloudinaryConfig._internal();

  // Cloudinary instance
  late Cloudinary cloudinary;

  // Initialize method
  void initialize() {
    cloudinary = Cloudinary.fromCloudName(
      cloudName: 'dosqd0oni',
      apiKey: '526428853213684'
    );
  }

  // Getter to access Cloudinary instance
  static Cloudinary get instance {
    return _instance.cloudinary;
  }

  Future<String?> uploadImage(File imageFile) async {
    try {
      final url = Uri.parse("https://api.cloudinary.com/v1_1/dosqd0oni/image/upload");

      var request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = 'ecotrack'
        ..fields['api_key'] = '526428853213684'
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        return jsonResponse["secure_url"];
      } else {
        print("Upload failed: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("Upload error: $e");
      return null;
    }
  }
}

