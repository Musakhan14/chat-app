// ignore_for_file: avoid_print, unused_local_variable

import 'package:chat_appp/models/user_model.dart';
import 'package:chat_appp/pages/home_page.dart';
import 'package:chat_appp/pages/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == '' || password == '') {
      print('Please fill all the fields');
    } else {
      print('Signup  successful');
      logIn(email, password);
    }
    emailController.clear();
    passwordController.clear();
  }

  void logIn(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }

    if (credential != null) {
      String uId = credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection('users').doc(uId).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      print('Login successful');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            firebaseUser: credential!.user!,
            userModel: userModel,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                children: [
                  const Text(
                    'Chat App',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(hintText: 'email'),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(hintText: 'password'),
                  ),
                  const SizedBox(height: 14),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text('Login'),
                    onPressed: () {
                      logIn(emailController.text, passwordController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Don\'t have an account!',
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              child: const Text(
                'SignUp',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
