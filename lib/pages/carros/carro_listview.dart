import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/pages/carros/carro_page.dart';
import 'package:carros/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'carro.dart';

class CarrosListView extends StatelessWidget {
  List<Carro> carros;

  CarrosListView(this.carros);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView.builder(
          itemCount: carros != null ? carros.length : 0,
          itemBuilder: (context, index) {
            Carro carro = carros[index];
            return Container(
              height: 280,
              child: InkWell(
                onTap: () {
                  _onClickCarro(carro, context);
                },
                onLongPress: () {
                  _onLongClickCarro(carro, context);
                },
                child: Card(
                  color: Colors.grey[100],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                            child: CachedNetworkImage(
                          imageUrl: carro.urlFoto ??
                              "http://www.livroandroid.com.br/livro/carros/esportivos/MERCEDES_BENZ_AMG.png",
                          width: 200,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )),
                        Text(carro.nome ?? "Sem nome",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 25,
                            )),
                        Text("descrição...",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                            )),
                        ButtonBarTheme(
                          data: ButtonBarTheme.of(context),
                          child: ButtonBar(
                            children: <Widget>[
                              FlatButton(
                                child: const Text('DETALHES'),
                                onPressed: () => _onClickCarro(carro, context),
                              ),
                              FlatButton(
                                child: const Text('SHARE'),
                                onPressed: () {
                                  _onClickShare(carro, context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _onClickCarro(Carro carro, context) {
    push(context, CarroPage(carro));
  }

  void _onLongClickCarro(Carro carro, BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  carro.nome,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                title: Text("Detalhes"),
                leading: Icon(Icons.directions_car),
                onTap: () {
                  pop(context);
                  _onClickCarro(carro, context);
                },
              ),
              ListTile(
                title: Text("Share"),
                leading: Icon(Icons.share),
                onTap: () {
                  pop(context);
                  _onClickShare(carro, context);
                },
              ),
            ],
          );
        });
  }

  void _onClickShare(Carro carro, BuildContext context) {
    print(carro.nome);
    Share.share(carro.urlFoto);
  }
}
