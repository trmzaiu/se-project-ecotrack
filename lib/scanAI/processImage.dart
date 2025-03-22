import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://wastesortapp.onrender.com/classify";

  static Future<String?> classifyImage(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseData);
        String predicted = jsonResponse["prediction"];
        
        Map<String, String> categoryMap = {
          "Plastic": "Recyclable", "Paper": "Recyclable", "Glass": "Recyclable",
          "Metal": "Recyclable", "Cardboard": "Recyclable", "Cans": "Recyclable",
          "Vehicle": "Recyclable", "Air Condition": "Recyclable",
          "Furniture": "Recyclable", "Faucet": "General",

          "Electronic": "Hazardous", "Medical": "Hazardous", "Chemical": "Hazardous",
          "Toxic": "Hazardous", "LED": "Hazardous", "Batteries": "Hazardous",
          "Computer Mouse": "Hazardous", "Game pad": "Hazardous",

          "Used Tissue": "General", "Packaging": "General","Clothes": "General",
          "Wrapper": "General", "Polystyrene": "General",
          "Fabric": "General", "Ceramic": "General",
          "Toothbrush": "General", "Sponges": "General",
          "Rubber": "General", "Cross": "General",
          "Bag": "General", "Curtain": "General",

          "Organic": "Organic", "Man": "Organic", "Woman": "Organic",
          "Person": "Organic", "Animal": "Organic", "Fruit": "Organic",
          "Flower": "Organic", "Cake": "Organic",
        };
        // Get category, default to "Unknown" if not found
        return categoryMap[predicted];
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }
}
