import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Ink roundedButton({
  required Color backgroundColor,
  required String buttonText,
  bool apploadingstate=false,
}) {
  return Ink(
    height: 50,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: backgroundColor,
    ),
    child: Center(
      child: apploadingstate?CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 4,
      ): Text(buttonText, style: TextStyle(color: Colors.white)),
    ),
  );
}
