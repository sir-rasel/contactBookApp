import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

formResponseMassage(String message, BuildContext context) {
  Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.TOP,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 20.0
  );
}