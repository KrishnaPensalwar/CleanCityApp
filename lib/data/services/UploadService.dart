import 'dart:convert';
import 'dart:io';
import 'package:cleancity/data/model/upload/UploadRequest.dart';
import 'package:cleancity/data/model/upload/UploadResponse.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;

class UploadService {
  final String baseUrl = "https://cleancity-backend-3euk.onrender.com";

  Future<File> compressImage(File file, {int quality = 70}) async {
    final bytes = await file.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return file;

    final compressedBytes = img.encodeJpg(image, quality: quality);
    final tempFile = File('${file.path}_compressed.jpg');
    await tempFile.writeAsBytes(compressedBytes);
    return tempFile;
  }

  Future<UploadResponse?> uploadImage(File imageFile, UploadRequest requestData) async {
    try {
      final compressedFile = await compressImage(imageFile);

      final uri = Uri.parse("$baseUrl/api/queries/upload");
      var request = http.MultipartRequest("POST", uri)
        ..headers.addAll({
          "Connection": "keep-alive",
        });

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        compressedFile.path,
      ));

      request.fields.addAll(requestData.toMap());

      var streamedResponse = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception("Upload timed out");
        },
      );

      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return UploadResponse.fromJson(jsonDecode(response.body));
      } else {
        return UploadResponse(
          status: "error",
          message: "Failed with status ${response.statusCode}",
        );
      }
    } catch (e) {
      return UploadResponse(
        status: "error",
        message: "Exception: $e",
      );
    }
  }
}
