import 'package:carros/pages/login/usuario.dart';
import 'package:http/http.dart' as http;

Future<http.Response> get(String url) async {
  print(url);

  final headers = await _headers();
  var response = await http.get(url, headers: headers);
  return response;
}

Future<http.Response> post(String url, {body}) async {
  print(url);

  final headers = await _headers();
  var response = await http.post(url, headers: headers, body: body);
  return response;
}

Future<http.Response> put(String url, {body}) async {
  print(url);
  final headers = await _headers();
  var response = await http.put(url, headers: headers, body: body);
  return response;
}

Future<http.Response> delete(String url) async {
  print(url);

  final headers = await _headers();
  var response = await http.delete(url, headers: headers);
  return response;
}

Future<Map<String, String>> _headers() async {
  Usuario usuario = await Usuario.get();
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${usuario.token}",
  };
  return headers;
}
