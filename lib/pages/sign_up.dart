import 'package:chat_appp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'complete_profile.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _LoginState();
}

class _LoginState extends State<SignUp> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String cPassword = cPasswordController.text.trim();
    if (email == '' || password == '' || cPassword == '') {
      print('Please fill all the fields');
    } else if (password != cPassword) {
      print('Password do not match');
    } else {
      print('Signup  successful');
      signUp(email, password);
    }
  }

  void signUp(String email, String password) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      print(e.code.toString());
    }

    if (credential != null) {
      String uId = credential.user!.uid;
      UserModel newUser = UserModel(
        uId: uId,
        email: email,
        fullName: '',
        profilePicture: '',
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .set(newUser.toMap())
          .then((value) {
        print('New User created');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompleteProfile(
              firebaseUser: credential!.user!,
              userModel: newUser,
            ),
          ),
        );
      });
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
                  TextField(
                    controller: cPasswordController,
                    decoration:
                        const InputDecoration(hintText: 'confirm password'),
                  ),
                  const SizedBox(height: 14),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text('SignUp'),
                    onPressed: () {
                      checkValues();
                      // emailController.clear();
                      // passwordController.clear();
                      // cPasswordController.clear();
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
              'Already have an account ?',
              style: TextStyle(fontSize: 16),
            ),
            CupertinoButton(
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
