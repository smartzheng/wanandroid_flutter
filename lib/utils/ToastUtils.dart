import 'package:flutter/material.dart';

class ToastUtils {
  static GlobalKey<ScaffoldState> scaffoldKey;

  static showToast(String message) {
    if (scaffoldKey == null) {
      scaffoldKey = new GlobalKey();
    }
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(message)));
  }

  static void showPrint(String message) {
    print("ToastUtils------------" + message);
  }
}
