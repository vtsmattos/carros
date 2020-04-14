import 'package:carros/favoritos/favorito_service.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_listview.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritosPage extends StatefulWidget {
  @override
  _FavoritosPageState createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage>
    with AutomaticKeepAliveClientMixin<FavoritosPage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder(
        stream:  FavoritoService().stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os carros");
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Carro> carros = snapshot.data.documents.map((DocumentSnapshot document) {
                return Carro.fromMap(document.data);
              }).toList();

          return CarrosListView(carros);
        });
  }
}
