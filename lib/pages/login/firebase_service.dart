import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/login/usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

String firebaseUserId;

class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse> login(String email, String senha) async {
    try {
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);

      final FirebaseUser user = authResult.user;

      print("Firebase nome: ${user.displayName}");
      print("Firebase email: ${user.email}");
      print("Firebase foto: ${user.photoUrl}");

      final usuario = Usuario(
          nome: user.displayName,
          login: user.email,
          email: user.email,
          urlFoto: user.photoUrl);
      usuario.save();
      saveUser(user);

      return ApiResponse.ok();
    } catch (e) {
      if (e.code == "ERROR_USER_NOT_FOUND" ||
          e.code == "ERROR_WRONG_PASSWORD") {
        return ApiResponse.error(msg: "Usuário/Senha inválido!");
      }
      print("Firebase error $e");
      return ApiResponse.error(msg: "Não foi possível realizar o login");
    }
  }

  Future<ApiResponse> loginGoogle() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      print("Google user: ${googleUser.email}");

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      print("Firebase nome: " + user.displayName);
      print("Firebase email: " + user.email);
      print("Firebase foto: " + user.photoUrl);

      final usuario = Usuario(
          nome: user.displayName,
          login: user.email,
          email: user.email,
          urlFoto: user.photoUrl);
      usuario.save();
      saveUser(user);

      return ApiResponse.ok();
    } catch (e) {
      print("Firebase error $e");
      return ApiResponse.error(msg: "Não foi possível realizar o login");
    }
  }

  logout() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<ApiResponse> cadastrar(String nome, String email, String senha) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      final FirebaseUser user = result.user;

      final userUpdateInfo = UserUpdateInfo();
      userUpdateInfo.displayName = nome;
      userUpdateInfo.photoUrl =
          "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50";

      user.updateProfile(userUpdateInfo);

      final usuario = Usuario(
          nome: user.displayName,
          login: user.email,
          email: user.email,
          urlFoto: user.photoUrl);
      usuario.save();

      return ApiResponse.ok(msg: "Usuario criado com sucesso!");
    } catch (e) {
      print("Firebase error $e");
      if (e is PlatformException) {
        return ApiResponse.error(
            msg: "Erro ao criar usuário. \n\n ${e.message}");
      }
      return ApiResponse.error(msg: "Não foi possível criar o usuário.");
    }
  }

  void saveUser(FirebaseUser user) {
    if (user != null) {
      firebaseUserId = user.uid;
      DocumentReference refUser =
          Firestore.instance.collection("users").document(firebaseUserId);

      refUser.setData({
        'nome': user.displayName,
        'email': user.email,
        'login': user.email,
        'urlFoto': user.photoUrl,
      });
    }
  }
}
