import 'package:flutter/material.dart';

void snackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(msg),
    duration: const Duration(milliseconds: 500),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
