import 'package:carros/favoritos/favoritos_model.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_listview.dart';
import 'package:carros/widgets/text_error.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    /**
     * With BLOC pattern
    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context, listen: false);
    favoritosBloc.fetch();
     */

    Provider.of<FavoritosModel>(context, listen: false).getCarros();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    FavoritosModel model = Provider.of<FavoritosModel>(context);
    List<Carro> carros = model.carros;
    if (carros.isEmpty) {
      return Center(child: TextError("Não temos carros nos favoritos"));
    }
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CarrosListView(carros),
    );

/**
 * Only use with bloc pattern
    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);
    return StreamBuilder(
        stream: favoritosBloc.stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return TextError("Não foi possível buscar os carros");
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Carro> carros = snapshot.data;
          return RefreshIndicator(
              onRefresh: _onRefresh, child: CarrosListView(carros));
        });

         */
  }

/*
  @override
  void dispose() {
    super.dispose();
    favoritosBloc.dispose();
  }
*/
  Future<void> _onRefresh() {
    /**
 * Only use with bloc pattern
    FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);
    return favoritosBloc.fetch();
    */

    return Provider.of<FavoritosModel>(context, listen: false).getCarros();
  }
}
