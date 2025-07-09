import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_practice/UI/posts/post_screen.dart';
import 'package:firebase_practice/UI/sign_up_screen.dart';
import 'package:firebase_practice/provider/loading_provider.dart';
import 'package:firebase_practice/provider/login_provider.dart';
import 'package:firebase_practice/utils/utils.dart';
import 'package:firebase_practice/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //firebase auth
  final auth = FirebaseAuth.instance;

  var formKey = GlobalKey<FormFieldState>();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  void login() {
    auth
        .signInWithEmailAndPassword(
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
              backgroundColor: Colors.green,
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 25),
                  Text(
                    "Login  Success",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              elevation: 6,
              margin: EdgeInsets.all(16),
              duration: Duration(seconds: 3),
            ),
          );

          //Next Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        })
        .onError((error, stackTrace) {
          ref.read(loadingProvider).changeLoadingState(false);
          Utils().toastMessage(error.toString().split('] ').last);
        });
  }

  @override
  Widget build(BuildContext context) {
    final emailErrorTextFromProvider = ref.watch(loginProvider).emailErrorText;
    final passwordErrorTextFromProvider =
        ref.watch(loginProvider).passwordErrorText;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("Login", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
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
                      ref.read(loginProvider).onChangedEmailValidation(value);
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    focusNode: passwordFocusNode,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    onChanged: (value) {
                      ref
                          .read(loginProvider)
                          .onChangedPasswordValidation(value);
                    },
                    forceErrorText:
                        passwordErrorTextFromProvider.isEmpty
                            ? null
                            : passwordErrorTextFromProvider,
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      labelText: "Password",

                      prefixIcon: Icon(Icons.lock),
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
                    .read(loginProvider)
                    .validateBothEmailAndPassword(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    )) {
                  login();
                  ref.read(loadingProvider).changeLoadingState(true);
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              child: roundedButton(
                apploadingstate: ref.watch(loadingProvider).isLoading,
                backgroundColor: Colors.deepPurple,
                buttonText: "Login",
              ),
            ),
            SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account ?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text("Sign up"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
