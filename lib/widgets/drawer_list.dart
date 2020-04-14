import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:carros/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<FirebaseUser> future = FirebaseAuth.instance.currentUser();

    //Future<Usuario> future = Usuario.get();

    return SafeArea(
      child: Drawer(
          child: ListView(
        children: <Widget>[
          FutureBuilder<FirebaseUser>(
            future: future,
            builder: (context, snapshot) {
              FirebaseUser usuario = snapshot.data;
              return usuario != null ? _header(usuario) : Container();
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text("Favoritos"),
            subtitle: Text("Mais informações..."),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              print("Item 1");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Ajuda"),
            subtitle: Text("Mais informações..."),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              print("Item 1");
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Logout"),
            trailing: Icon(Icons.arrow_forward),
            onTap: () => _onClickLogout(context),
          ),
        ],
      )),
    );
  }

  _header(FirebaseUser usuario) {
    return UserAccountsDrawerHeader(
      accountName: Text(usuario.displayName ?? ""),
      accountEmail: Text(usuario.email),
      currentAccountPicture: usuario.photoUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(usuario.photoUrl),
            )
          : FlutterLogo(),
    );
  }

  _onClickLogout(BuildContext context) {
    Usuario.clear();
    FirebaseService().logout();
    Navigator.pop(context);
    push(context, LoginPage(), replace: true);
  }
}
