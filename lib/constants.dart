import 'package:flutter/material.dart';

class Constants {
  void showInSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // width: 200,
        showCloseIcon: true,
        closeIconColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        content: SizedBox(child: Text(message)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
