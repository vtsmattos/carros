import 'package:flutter/material.dart';

Future<String> push(context, page, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  } else {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return page;
    }));
  }
}

bool pop<T extends Object>(BuildContext context,[T result]){
  return Navigator.pop(context);
}
