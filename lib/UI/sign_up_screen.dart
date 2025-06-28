import 'package:firebase_practice/UI/login_screen.dart';
import 'package:firebase_practice/provider/login_provider.dart';
import 'package:firebase_practice/provider/signup_provider.dart';
import 'package:firebase_practice/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("SignUp  Success")));
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              child: roundedButton(
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
