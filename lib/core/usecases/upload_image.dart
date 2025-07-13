import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/cloudinary.dart';

Future<String?> uploadImageToCloudinary(
  String filePath, {
  String folder = 'profile',
}) async {
  final url = Uri.parse(
    'https://api.cloudinary.com/v1_1/$cloudinaryCloudName/image/upload',
  );
  final request =
      http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'ml_default'
        ..fields['folder'] = folder
        ..files.add(await http.MultipartFile.fromPath('file', filePath));

  final response = await request.send();
  if (response.statusCode == 200) {
    final respStr = await response.stream.bytesToString();
    final data = json.decode(respStr);
    return data['secure_url'];
  }
  return null;
}
