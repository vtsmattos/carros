import 'package:carros/pages/carros/loripsum_api.dart';
import 'package:carros/pages/carros/simple_bloc.dart';

class LoripsumBloc extends StringBloc {

static String lorim;

  fetch() async {
      String s = lorim ?? await LoripsumApi.getText();
      lorim = s;
      add(s);
  }
}
