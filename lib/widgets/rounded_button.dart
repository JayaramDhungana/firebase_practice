import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Ink roundedButton({
  required Color backgroundColor,
  required String buttonText,
}) {
  return Ink(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: backgroundColor,
    ),
    child: Center(
      child: Text(buttonText, style: TextStyle(color: Colors.white)),
    ),
  );
}
