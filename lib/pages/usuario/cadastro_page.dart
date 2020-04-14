import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/home_page.dart';
import 'package:carros/pages/login/firebase_service.dart';
import 'package:carros/pages/login/login_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/app_button.dart';
import 'package:flutter/material.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _tNome = TextEditingController();
  final _tEmail = TextEditingController();
  final _tSenha = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _progress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cadastro"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: _body(context),
      ),
    );
  }

  _body(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          _textFormField(_tNome, "Nome",
              validator: _validateNome, hint: "Digite o nome"),
          _textFormField(_tEmail, "E-mail",
              validator: _validateEmail, hint: "Digite o e-mail"),
          _textFormField(_tSenha, "Senha",
              validator: _validateSenha, hint: "Digite a senha",
              obscureText: true),
          AppButton(
            "Cadastrar",
            onPressed: () => _onClickCadastrar(context),
            showProgress: _progress,
          ),
          _cancelarButtom(context),
        ],
      ),
    );
  }

  TextFormField _textFormField(TextEditingController _controller, String label,
      {Function validator, String hint, bool obscureText = false}) {
    return TextFormField(
      controller: _controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.blue, fontSize: 22),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 22,
        ),        
        hintText: hint ?? "",
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
        ),
      ),
    );
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Digite o nome";
    }
    if (text.length < 3) {
      return "A nome deverá possuir pelo menos 3 caracteres";
    }
  }

  String _validateEmail(String text) {
    if (text.isEmpty) {
      return "Digite o e-mail";
    }
    if (text.length < 3) {
      return "A e-mail deverá possuir pelo menos 3 números";
    }
    if (text.indexOf("@") < 0) {
      return "E-mail inválido!";
    }
  }

  String _validateSenha(String text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    if (text.length < 3) {
      return "A senha deverá possuir pelo menos 3 números";
    }
  }

  _onClickCadastrar(context) async {
    print("Cadastrar");
    String nome = _tNome.text;
    String email = _tEmail.text;
    String senha = _tSenha.text;

    print("Nome: $nome, Email: $email, Senha: $senha");
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _progress = true;
    });

    final service = FirebaseService();
    final ApiResponse response = await service.cadastrar(nome, email, senha);

    if (response.ok) {
      push(context, HomePage(), replace: true);
    } else {
      alert(context, "Error", msg: response.msg);
    }

    setState(() {
      _progress = false;
    });
  }

  _onClickCancelar(context) {
    push(context, LoginPage(), replace: true);
  }

  _cancelarButtom(context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 46,
      child: RaisedButton(
        onPressed: () => _onClickCancelar(context),
        color: Colors.white,
        child: _progress
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 22,
                ),
              ),
      ),
    );
  }
}
