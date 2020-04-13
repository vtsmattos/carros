import 'package:carros/favoritos/favorito_service.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/simple_bloc.dart';

class FavoritosBloc extends SimpleBloc<List<Carro>> {
  Future<List<Carro>> fetch() async {
    try {
      List<Carro> carros = await FavoritoService.getCarros();
      add(carros);

      return carros;
    } catch (e) {
      addError(e);
    }
  }
}
