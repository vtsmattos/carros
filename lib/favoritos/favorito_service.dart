import 'package:carros/favoritos/favorito.dart';
import 'package:carros/favoritos/favorito_dao.dart';
import 'package:carros/favoritos/favoritos_bloc.dart';
import 'package:carros/favoritos/favoritos_model.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:provider/provider.dart';

class FavoritoService {
  static Future<bool> favoritar(context, Carro c) async {
    bool favorito = false;
    Favorito f = Favorito.fromCarro(c);
    final dao = FavoritoDao();
    final exists = await dao.exists(c.id);
    if (exists) {
      dao.delete(c.id);
    } else {
      dao.save(f);
      favorito = true;
    }
    //using pattern BLOC
    //FavoritosBloc favoritosBloc = Provider.of<FavoritosBloc>(context);
    //favoritosBloc.fetch();
    
    //with default Provider
    Provider.of<FavoritosModel>(context, listen: false).getCarros();
    return favorito;
  }

  static Future<List<Carro>> getCarros() async {
    List<Carro> carros = await CarroDAO().getCarros();
    return carros;
  }

  static Future<bool> isFavorito(Carro c) async {
    final dao = FavoritoDao();
    final exists = await dao.exists(c.id);
    return exists;
  }
}
