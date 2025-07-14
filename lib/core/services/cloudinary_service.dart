import 'package:cloudinary_public/cloudinary_public.dart';

class CloudinaryService {
  static final cloudinary = CloudinaryPublic('dume7lvn5', 'ml_default');

  static Future<String> uploadImage(
    String filePath, {
    bool isGroup = true,
  }) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          filePath,
          resourceType: CloudinaryResourceType.Image,
          folder: "fairshare/${isGroup ? "groups/" : "profiles"}",
        ),
      );
      return response.secureUrl;
    } catch (e) {
      print((e as dynamic).response);
      throw Exception('Failed to upload image: $e');
    }
  }
}
