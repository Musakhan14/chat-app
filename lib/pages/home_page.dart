import 'package:chat_appp/pages/search_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../custom_drawe.dart';
import '../models/user_model.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const HomePage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: CustomDrawer(
          email: widget.userModel.email.toString(),
          name: widget.userModel.fullName.toString(),
          profilePictureUrl: widget.userModel.profilePicture.toString(),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text('IChat'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(
                    userModel: widget.userModel,
                    firebaseUser: widget.firebaseUser),
              ),
            );
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
