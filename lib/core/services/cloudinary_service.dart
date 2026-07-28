import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class CloudinaryService {
  static const _cloudName = 'ld12oryx';
  static const _apiKey = '795647131558756';
  static const _uploadUrl = 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  Future<String?> uploadImage(File file) async {
    try {
      final ext = p.extension(file.path).replaceAll('.', '');
      final mimeType = ext == 'png' ? 'image/png' : 'image/jpeg';
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.fields['upload_preset'] = 'mymood_upload';
      request.fields['api_key'] = _apiKey;
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType.parse(mimeType),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        final body = response.body;
        final start = body.indexOf('"secure_url":"') + 14;
        final end = body.indexOf('"', start);
        if (start > 13 && end > start) {
          return body.substring(start, end).replaceAll(r'\u0026', '&');
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
