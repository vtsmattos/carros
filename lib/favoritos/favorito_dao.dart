import 'package:carros/favoritos/favorito.dart';
import 'package:carros/utils/sql/base_dao.dart';

class FavoritoDao extends BaseDAO<Favorito> {

  @override
  Favorito fromMap(Map<String, dynamic> map) {
    return Favorito.fromMap(map);
  }

  @override
  String get tableName => "favorito";
}
