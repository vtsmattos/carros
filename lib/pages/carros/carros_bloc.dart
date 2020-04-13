import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_dao.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';
import 'package:carros/utils/network.dart';

class CarrosBloc extends SimpleBloc<List<Carro>> {
  Future<List<Carro>> fetch(TipoCarro tipo) async {
    try {
      List<Carro> carros;
      if (!await isNetworkOn()) {
        String s = tipo.toString().replaceAll("TipoCarro.", "");
        carros = CarroDAO().findAllByTipo(s) as List<Carro>;
      }
      carros = await CarroApi.getCarros(tipo);
      add(carros);

      if (!carros.isEmpty) {
        carros.forEach((c) => CarroDAO().save(c));
      }

      return carros;
    } catch (e) {
      addError(e);
    }
  }
}
