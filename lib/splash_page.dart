import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/utils/sql/db_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    //Future<Usuario> futureUser = Usuario.get();
    Future<FirebaseUser> futureUser = FirebaseAuth.instance.currentUser();
    
    Future futureDB = DatabaseHelper.getInstance().db;
    Future.delayed(Duration(seconds: 1));

    Future.wait([futureUser, futureDB]).then((List values) {
      FirebaseUser u = values[0];
      if (u != null && u.email != null) {
        push(context, HomePage(), replace: true);
      }
      else{
        push(context, LoginPage(), replace: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue[200],
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
