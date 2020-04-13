import 'package:cached_network_image/cached_network_image.dart';
import 'package:carros/favoritos/favorito_service.dart';
import 'package:carros/pages/api_response.dart';
import 'package:carros/pages/carros/carro.dart';
import 'package:carros/pages/carros/carro_form_page.dart';
import 'package:carros/pages/carros/carros_api.dart';
import 'package:carros/pages/carros/loripsum_bloc.dart';
import 'package:carros/pages/maps/google_map_page.dart';
import 'package:carros/pages/video_page.dart';
import 'package:carros/utils/alert.dart';
import 'package:carros/utils/event_bus.dart';
import 'package:carros/utils/nav.dart';
import 'package:carros/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarroPage extends StatefulWidget {
  Carro carro;

  CarroPage(this.carro);

  @override
  _CarroPageState createState() => _CarroPageState();
}

class _CarroPageState extends State<CarroPage> {
  final _loripsumBloc = LoripsumBloc();

  Carro get carro => widget.carro;
  Color color = Colors.grey;

  @override
  void initState() {
    super.initState();

    FavoritoService.isFavorito(carro).then((favorito) {
      setState(() {
        color = favorito ? Colors.red : Colors.grey;
      });
    });
    _loripsumBloc.fetch();
  }

  @override
  void dispose() {
    super.dispose();
    _loripsumBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carro.nome),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.place),
            onPressed: _onClickMap,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () => _onClickVideo(context),
          ),
          PopupMenuButton<String>(
            onSelected: _onClickPopMenu,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: "Editar",
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: "Deletar",
                  child: Text("Deletar"),
                ),
                PopupMenuItem(
                  value: "Share",
                  child: Text("Share"),
                )
              ];
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ListView(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: widget.carro.urlFoto ??
                "http://www.livroandroid.com.br/livro/carros/esportivos/MERCEDES_BENZ_AMG.png",
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          bloco1(),
          Divider(),
          bloco2(),
        ],
      ),
    );
  }

  Row bloco1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            text(widget.carro.nome, fontSize: 20, bold: true),
            text(widget.carro.tipo, fontSize: 16),
          ],
        ),
        Row(
          children: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: color,
                  size: 40,
                ),
                onPressed: _onClickFavorite),
            IconButton(
                icon: Icon(
                  Icons.share,
                  size: 40,
                ),
                onPressed: _onClickShare),
          ],
        )
      ],
    );
  }

  void _onClickMap() {
    if (carro.latitude != null && carro.longitude != null) {
      push(context, GoogleMapPage(carro));
    } else {
      alert(
        context,
        "Erro",
        msg: "Esse carro não possui dados de localização",
      );
    }
  }

  void _onClickVideo(BuildContext context) {
    if (carro.urlVideo != null && carro.urlVideo.isNotEmpty) {
      //launch(carro.urlVideo);
      push(context, VideoPage(carro));
    } else {
      alert(
        context,
        "Erro",
        msg: "Esse carro não possui vídeo",
      );
    }
  }

  _onClickPopMenu(String value) {
    switch (value) {
      case "Editar":
        push(
            context,
            CarroFormPage(
              carro: carro,
            ));
        print("Editar");
        break;
      case "Deletar":
        print("Deletar");
        deletar();
        break;
      case "Share":
        print("Share");
        break;
    }
  }

  void _onClickFavorite() async {
    bool favorito = await FavoritoService.favoritar(context, carro);
    setState(() {
      color = favorito ? Colors.red : Colors.grey;
    });
  }

  void _onClickShare() {}

  bloco2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        text(widget.carro.descricao, fontSize: 16, bold: true),
        SizedBox(
          height: 20,
        ),
        StreamBuilder<String>(
            stream: _loripsumBloc.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return text(snapshot.data, fontSize: 16);
            }),
      ],
    );
  }

  Future<void> deletar() async {
    ApiResponse<bool> response = await CarroApi.delete(carro);
    if (response.ok) {
      alert(context, "Carro deletado com sucesso", callback: () {
        final bus = EventBus.get(context);
        bus.sendEvent(CarroEvent("carro_deletado", _getTipoEnum(carro.tipo)));
        pop(context);
      });
    } else {
      alert(context, response.msg);
    }
  }

  TipoCarro _getTipoEnum(String tipoCarro) {
    switch (tipoCarro) {
      case "classicos":
        return TipoCarro.classicos;
      case "esportivos":
        return TipoCarro.esportivos;
      case "luxo":
        return TipoCarro.luxo;
    }
  }
}
