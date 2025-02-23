import 'package:cloudinary_url_gen/cloudinary.dart';

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
}