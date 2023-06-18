import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CallToast {
  void showToastMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
    );
  }
}
