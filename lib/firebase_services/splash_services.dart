import 'dart:async';

import 'package:firebase_practice/UI/login_screen.dart';
import 'package:firebase_practice/UI/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SplashServices {
  isLogin(BuildContext context) {
    Timer(Duration(seconds: 5), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }
}
