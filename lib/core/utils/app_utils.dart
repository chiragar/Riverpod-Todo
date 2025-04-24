import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showNativeToast(String message, {bool isError = false}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: isError ? Colors.red : Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
