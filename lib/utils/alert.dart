import 'package:flutter/material.dart';


  alert(BuildContext context, String title, {String msg = "", Function callback}) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: Text(title) ?? "",
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if(callback != null){
                        callback();
                      }
                    },
                    child: Text("Ok")),
              ],
            ),
          );
        });
  }
