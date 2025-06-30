import 'package:firebase_practice/UI/login_screen.dart';
import 'package:firebase_practice/provider/loading_provider.dart';
import 'package:firebase_practice/provider/login_provider.dart';
import 'package:firebase_practice/provider/signup_provider.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  //Text Editing Controller haru
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  //FocusNode haru
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  //form key
  final formKey = GlobalKey<FormState>();
  //Dispose
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    emailFocusNode.dispose();
    passwordController.dispose();
    passwordFocusNode.dispose();
  }

  ///now Firebase Authentication
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final emailErrorTextFromProvider = ref.watch(signupProvider).emailErrorText;
    final passwordErrorTextFromProvider =
        ref.watch(signupProvider).passwordErrorText;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("Sign up", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      ref.read(signupProvider).onChangedEmailValidation(value);
                    },
                    forceErrorText:
                        emailErrorTextFromProvider.isEmpty
                            ? null
                            : emailErrorTextFromProvider,
                    controller: emailController,
                    focusNode: emailFocusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    onChanged: (value) {
                      ref
                          .read(signupProvider)
                          .onChangedPasswordValidation(value);
                    },
                    forceErrorText:
                        passwordErrorTextFromProvider.isEmpty
                            ? null
                            : passwordErrorTextFromProvider,
                    controller: passwordController,
                    obscureText: true,
                    focusNode: passwordFocusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                if (ref
                    .read(signupProvider)
                    .validateBothEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    )) {
                  ref.read(loadingProvider).changeLoadingState(true);
                  _auth
                      .createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      )
                      .then((value) {
                        ref.read(loadingProvider).changeLoadingState(false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            content: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.white),
                                SizedBox(width: 25),
                                Text(
                                  "SignUp  Success",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 3),
                            margin: EdgeInsets.all(16),
                            elevation: 6,
                          ),
                        );
                      })
                      .onError((error, stackTrace) {
                        ref.read(loadingProvider).changeLoadingState(false);
                        Utils().toastMessage(error.toString().split('] ').last);
                      });
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              child: roundedButton(
                apploadingstate: ref.watch(loadingProvider).isLoading,
                backgroundColor: Colors.deepPurple,
                buttonText: "Sign Up",
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an Account ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("Log in"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
