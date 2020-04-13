import 'dart:convert';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;

class LoginApi {
  static Future<ApiResponse> loginJWT(login, senha) async {
    try {
      var url = 'http://carros-springboot.herokuapp.com/api/v2/login';

      Map<String, String> headers = {
        "Content-Type": "application/json",
      };
      Map params = {
        "username": login,
        "password": senha,
      };

      String user = json.encode(params);

      var response = await http.post(url, body: user, headers: headers);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      Map mapResponse = json.decode(response.body);

      if (response.statusCode == 200) {
        final user = Usuario.fromJson(mapResponse);
        user.save();
        
        return ApiResponse.ok(user);
      } else {
        return ApiResponse.error(mapResponse["error"]);
      }
    } catch (erro, exception) {
      print("Erro no login $erro > $exception");

      return ApiResponse.error("Não foi possível fazer o login.");
    }
  }

  static Future<bool> login(login, senha) async {
    var url = 'http://livrowebservices.com.br/rest/login';

    Map params = {
      'login': login,
      'senha': senha,
    };

    var response = await http.post(url, body: params);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return true;
  }
}
