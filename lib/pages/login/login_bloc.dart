import 'dart:async';

import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/pages/login/login_api.dart';

class LoginBloc {
  final buttonBloc = BooleanBloc();

  Future<ApiResponse> login(login, senha) async {
    buttonBloc.add(true);
    ApiResponse response = await LoginApi.loginJWT(login, senha);
    buttonBloc.add(false);

    return response;
  }


  void dispose() {
    buttonBloc.dispose();
  }
}
