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

        Map<String, List<String>> categoryMap = {
          "Recyclable": [
            "Plastic", "Plastic Bottle", "Plastic Bag", "Plastic Cup",
            "Paper", "Newspaper", "Cardboard", "Magazine", "Brochure", "Wood",
            "Carton", "Paper Box", "Envelope", "Glass", "Glass Bottle", "Jar",
            "Metal", "Aluminum Can", "Tin Can", "Metal Lid", "Plastic Utensils",
            "Cans", "Air Condition", "Furniture", "Ceramic", "Plastic Straw",
          ],
          "Hazardous": [
            "Electronic", "Smartphone", "Laptop", "Computer Mouse", "Game pad",
            "Broken TV", "Charger", "Circuit Board", "Medical", "Syringe", "Pill Bottle",
            "LED", "Fluorescent Bulb", "Batteries", "Chemical", "Bleach Bottle",
            "Paint Can", "Toxic"
          ],
          "General": [
            "Used Tissue", "Packaging", "Dirty Packaging", "Wrapper", "Food Wrapper", "Chip Bag",
            "Styrofoam", "Polystyrene", "Candy Wrapper", "Plastic Glove", "Sponges", "Rubber",
            "Crocs", "Fabric", "Clothes", "Toothbrush", "Curtain", "Bag", "Mirror", "Plush Toy",
            "Toy", "Shoes", "Slippers", "Pen", "Highlighter", "Vehicle",
          ],
          "Organic": [
            "Organic", "Fruit", "Vegetable", "Food",
            "Banana Peel", "Apple Core", "Orange Peel", "Coffee Grounds", "Tea Bag", "Eggshells",
            "Bread", "Cake", "Rice", "Pasta", "Flower", "Leaves", "Grass", "Plant", "Meat",
            "Fish", "Bone", "Corn Cob", "Coconut Shell", "Animal Waste",
          ],
          "Unknown": [
            "Man", "Woman", "Person", "Human", "Animal"
          ]
        };
        // Get category, default to "Unknown" if not found
        String result = categoryMap.entries.firstWhere(
              (entry) => entry.value.contains(predicted),
          orElse: () => const MapEntry("Unknown", []),
        ).key;

        return result;
      } else {
        return "Error";
      }
    } catch (e) {
      return "Error";
    }
  }
}
