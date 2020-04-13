import 'package:http/http.dart' as http;

class LoripsumApi{
static Future<String> getText() async {
  var url = "http://loripsum.net/api";

  print("GET > $url");

  var response = await http.get(url);
  String text = response.body;
  text = text.replaceAll("<p>", "");
  text = text.replaceAll("</p>", "");
  return text;

}
}