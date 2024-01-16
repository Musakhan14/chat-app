import 'package:chat_appp/const/theme_data.dart';
import 'package:chat_appp/models/fireabsae_helper.dart';
import 'package:chat_appp/models/user_model.dart';
import 'package:chat_appp/pages/home_page.dart';
import 'package:chat_appp/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
 var uuid=const Uuid();
void main() async {
  User? currentUser=FirebaseAuth.instance.currentUser;
  if(currentUser !=null){
    //Logged In
    UserModel? thisUserModel =await  FirebaseHelper.getUSerModelById(currentUser.uid);
    if(thisUserModel !=null){
      runApp(
        MyAppLoggedIn (userModel: thisUserModel, firebaseUser: currentUser));
    }else{
      runApp(const MyApp());
    }
  }else{
    runApp(const MyApp());
  }
}
// Not LoggedIn
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: themeData,
      home:  const LoginPage(),
    );
  }
}

//Already LoggedIn
class MyAppLoggedIn extends StatelessWidget {
  final UserModel userModel;
  final User firebaseUser;
  const MyAppLoggedIn({super.key, required this.userModel, required this.firebaseUser});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chat App',
      theme: themeData,
      home:   HomePage(userModel: userModel, firebaseUser: firebaseUser),
    );
  }
}