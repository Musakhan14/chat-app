import 'dart:io';

import 'package:chat_appp/models/user_model.dart';
import 'package:chat_appp/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CompleteProfile extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;

  const CompleteProfile(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<CompleteProfile> createState() => _LoginState();
}

class _LoginState extends State<CompleteProfile> {
  File? imageFile;
  TextEditingController fullNameController = TextEditingController();
  void selectImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 40,
    );
    if (pickedImage != null) {
      copyImage(file: pickedImage);
    }
  }

  void copyImage({required XFile file}) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 20,
    );

    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
        // imageFile = croppedImage as File;
      });
    }
  }

  void checkValues() {
    String fullName = fullNameController.text.trim();
    if (fullName == '' || imageFile == null) {
      print('Please fill all the fields');
    } else {
      print('Uploading');
      uploadData();
    }
  }

  void uploadData() async {
    // instance.ref mean creating folder for images
    //child use for naming your picture mean set a unique name
    UploadTask uploadTask = FirebaseStorage.instance
        .ref('profilePictures')
        .child(widget.userModel.uId.toString())
        .putFile(imageFile!);
    //wait for uploading the task
    TaskSnapshot snapshot = await uploadTask;
    //once its done we can get url of the image
    String imageUrl = await snapshot.ref.getDownloadURL();
    String fullName = fullNameController.text.trim();

    widget.userModel.fullName = fullName;
    widget.userModel.profilePicture = imageUrl;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userModel.uId)
        .set(widget.userModel.toMap())
        .then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            userModel: widget.userModel,
            firebaseUser: widget.firebaseUser,
          ),
        ),
      );
    });
  }

  void showImageOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'Upload Profile Picture',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_album),
                title: const Text('Select from Gallery'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet

                  // Handle gallery option here
                  selectImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Select from Camera'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the bottom sheet

                  // Handle camera option here
                  selectImage(ImageSource.camera);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: const Text('Complete Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CupertinoButton(
                  onPressed: () {
                    showImageOption(context);
                  },
                  child: CircleAvatar(
                    maxRadius: 60,
                    backgroundImage:
                        (imageFile != null) ? FileImage(imageFile!) : null,
                    child: (imageFile == null)
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: fullNameController,
                  decoration: const InputDecoration(hintText: 'full name'),
                ),
                const SizedBox(height: 14),
                CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text('Submit'),
                  onPressed: () {
                    checkValues();
                    print('Uploaded');
                  },
                ),
              ],
            ),
          )),
    );
  }
}
