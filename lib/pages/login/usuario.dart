import 'package:carros/utils/prefs.dart';
import 'dart:convert' as convert;

class Usuario {
  int id;
  String nome;
  String login;
  String email;
  String urlFoto;
  String token;
  List<String> roles;

  Usuario.fromJson(Map<String, dynamic> map)
      : this.id = map["id"],
        this.nome = map["nome"],
        this.login = map["login"],
        this.email = map["email"],
        this.urlFoto = map["urlFoto"],
        this.token = map["token"],
        this.roles = (map["roles"] == null)
            ? null
            : map["roles"].map<String>((role) => role.toString()).toList();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['login'] = this.login;
    data['email'] = this.email;
    data['urlFoto'] = this.urlFoto;
    data['token'] = this.token;
    data['roles'] = this.roles;
    return data;
  }

  save() {
    Map json = toJson();
    String userPrefs = convert.json.encode(json);
    Prefs.setString("user.prefs", userPrefs);
  }

  static Future<Usuario> get() async {
    String userPrefs = await Prefs.getString("user.prefs");
    if (userPrefs.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(userPrefs);
    Usuario user = Usuario.fromJson(map);
    return user;
  }

  static void clear() {
    Prefs.setString("user.prefs", "");
  }
}
