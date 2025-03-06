import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ApiService {
  // Replace with your actual Render deployed URL that forwards to Hugging Face
  static final String baseUrl = 'https://wastesortapp.onrender.com';

  // Classify image and return prediction
  static Future<String?> classifyImage(File imageFile) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/classify'));

      // Add file to request
      var fileStream = http.ByteStream(imageFile.openRead());
      var fileLength = await imageFile.length();

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        fileLength,
        filename: 'image.jpg',
      );

      request.files.add(multipartFile);

      // Send request with longer timeout due to potential model inference time
      var streamedResponse = await request.send().timeout(const Duration(seconds: 30));
      var response = await http.Response.fromStream(streamedResponse);

      // Handle response
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        // Format the result with category and confidence
        double confidence = data['confidence'] * 100;
        return "${data['category']} (${confidence.toStringAsFixed(1)}%)";
      } else {
        debugPrint('Server error: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Classification error: $e');
      return null;
    }
  }

  // Health check to test API connection
  static Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
      ).timeout(const Duration(seconds: 10));

      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Health check error: $e');
      return false;
    }
  }
}