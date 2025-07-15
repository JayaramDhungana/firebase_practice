import 'package:flutter/material.dart';

SnackBar snackBarWidget(
  {
    required String textToShow,
  }
) {
  return SnackBar(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    backgroundColor: Colors.green,
    content: Row(
      children: [
        Icon(Icons.check_circle, color: Colors.white),
        SizedBox(width: 25),
        Text(
          textToShow,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    margin: EdgeInsets.all(16),
    duration: Duration(seconds: 3),
  );
}
