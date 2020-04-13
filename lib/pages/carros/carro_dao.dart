import 'package:carros/pages/carros/carro.dart';
import 'package:carros/utils/sql/base_dao.dart';

// Data Access Object
class CarroDAO extends BaseDAO<Carro> {
  @override
  String get tableName => "carro";

  @override
  Carro fromMap(Map<String, dynamic> map) => Carro.fromMap(map);

  Future<List<Carro>> findAllByTipo(String tipo) async {
    return await query('select * from $tableName where tipo =? ', [tipo]);
  }

  Future<List<Carro>> getCarros() async {
    return await query("select c.* from carro c inner join favorito f on f.id = c.id ");

  }
}
