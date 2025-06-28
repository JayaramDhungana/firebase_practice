import 'package:firebase_practice/provider/login_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final emailErrorTextFromProvider = ref.watch(loginProvider).emailErrorText;
    final passwordErrorTextFromProvider =
        ref.watch(loginProvider).passwordErrorText;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text("Login Screen", style: TextStyle(color: Colors.white)),
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

                      prefixIcon: Icon(Icons.password_sharp),
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
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Login  Success")));
                } else {
                  FocusScope.of(context).unfocus();
                }
              },
              child: roundedButton(
                backgroundColor: Colors.deepPurple,
                buttonText: "Login",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
