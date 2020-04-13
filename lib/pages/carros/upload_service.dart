import 'dart:async';
import 'dart:convert' as convert;
import 'dart:io';

import 'package:carros/pages/api_response.dart';
import 'package:carros/utils/http_helper.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class UploadService {
  static Future<ApiResponse<String>> upload(File file) async {
    try {
      String url = "https://carros-springboot.herokuapp.com/api/v2/upload";

      List<int> imageBytes = file.readAsBytesSync();
      String base64Image = convert.base64Encode(imageBytes);

      String fileName = path.basename(file.path);

      var headers = {"Content-Type": "application/json"};

      var params = {
        "fileName": fileName,
        "mimeType": "image/jpeg",
        "base64": base64Image
      };

      String json = convert.jsonEncode(params);

      print("http.upload: " + url);
      print("params: " + json);

      final response = await post(
            url,
            body: json,
          )
          .timeout(
            Duration(seconds: 30),
            onTimeout: _onTimeOut,
          );

      if (response.statusCode == 200) {
        print("http.upload << " + response.body);

        Map<String, dynamic> map = convert.json.decode(response.body);

        String urlFoto = map["url"];

        return ApiResponse.ok(urlFoto);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error(
            "Não foi possível realizar o upload do arquivo");
      }
    } catch (e) {
      return ApiResponse.error("Não foi possível realizar o upload do arquivo");
    }
  }

  static FutureOr<http.Response> _onTimeOut() {
    print("timeout!");
    throw SocketException("Não foi possível se comunicar com o servidor.");
  }
}