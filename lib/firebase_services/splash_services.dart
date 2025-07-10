import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_practice/UI/login_screen.dart';
import 'package:firebase_practice/UI/posts/post_screen.dart';
import 'package:firebase_practice/UI/splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;

  isLogin(BuildContext context) {
    final user = auth.currentUser;

    if (user != null) {
      Timer(Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostScreen()),
        );
      });
    } else {
      Timer(Duration(seconds: 5), () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
    }
  }
}
