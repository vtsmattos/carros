import 'dart:convert' as convert;
import 'dart:io';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/upload_service.dart';
import 'package:carros/pages/login/usuario.dart';
import 'carro.dart';
import 'package:carros/utils/http_helper.dart' as http;

enum TipoCarro { classicos, esportivos, luxo }

class CarroApi {
  static Future<List<Carro>> getCarros(TipoCarro tipo) async {
    String s = tipo.toString().replaceAll("TipoCarro.", "");
    var url = "http://carros-springboot.herokuapp.com/api/v2/carros/tipo/$s";
    var response = await http.get(url);
    String json = response.body;
    List mapResponse = convert.json.decode(json);
    List carros = mapResponse.map((c) => Carro.fromMap(c)).toList();

    return carros;
  }

  static Future<ApiResponse<bool>> save(Carro c, File file) async {
    try {
      if (file != null) {
        ApiResponse<String> response = await UploadService.upload(file);
        if (response.ok) {
          c.urlFoto = response.result;
        }

      }
      var url = "http://carros-springboot.herokuapp.com/api/v2/carros";
      if (c.id != null) {
        url += "/${c.id}";
      }
      var response = await (c.id == null
          ? http.post(url, body: c.toJson())
          : http.put(url, body: c.toJson()));

      print("Response status: ${response.statusCode} ");
      print("Response body: ${response.body} ");

      Map mapResponse = convert.json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Carro carro = Carro.fromMap(mapResponse);
        print("Carro id: ${carro.id}");

        return ApiResponse.ok(true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error("Não foi possível salvar o carro");
      }
      return ApiResponse.error(mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error("Não foi possível salvar o carro");
    }
  }

  static Future<ApiResponse<bool>> delete(Carro c) async {
    try {
      var url = "http://carros-springboot.herokuapp.com/api/v2/carros";
      if (c.id != null) {
        url += "/${c.id}";
      }

      var response = await http.delete(url);
      print("Response status: ${response.statusCode} ");
      print("Response body: ${response.body} ");

      Map mapResponse = convert.json.decode(response.body);
      if (response.statusCode == 200) {
        return ApiResponse.ok(true);
      }

      if (response.body == null || response.body.isEmpty) {
        return ApiResponse.error("Não foi possível deletar o carro");
      }
      return ApiResponse.error(mapResponse["error"]);
    } catch (e) {
      return ApiResponse.error("Não foi possível deletar o carro");
    }
  }
}
