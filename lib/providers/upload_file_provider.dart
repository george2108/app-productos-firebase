import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;

class UploadFileProvider {
  Future<String> uploadFile(File file) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dlzmamhqf/image/upload?upload_preset=jbmwpjd4');
    final mimetype = mime(file.path).split('/');
    final imageUploadRequest = http.MultipartRequest('POST', url);
    final fileUpload = await http.MultipartFile.fromPath(
      // este parametro es como se llama el archivo recibido en el backend
      'file',
      file.path,
      contentType: MediaType(mimetype[0], mimetype[1]),
    );
    imageUploadRequest.files.add(fileUpload);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);
    if (response.statusCode != 200 && response.statusCode != 201) {
      print('algo salio mal');
      print(response.body);
      return null;
    }
    final data = json.decode(response.body);
    print(data);
    return data['secure_url'];
  }
}
