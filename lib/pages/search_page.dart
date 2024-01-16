import 'package:chat_appp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chat_room_model.dart';
import '../models/user_model.dart';
import 'chat_room.dart';

class SearchPage extends StatefulWidget {
  final UserModel userModel;
  final User firebaseUser;
  const SearchPage(
      {super.key, required this.userModel, required this.firebaseUser});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();

  Future<ChatRoomModel?> getChatRoomModel(UserModel targetUSer) async {
    ChatRoomModel? chatRoom;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants.${widget.userModel.uId}', isEqualTo: true)
        .where('participants.${targetUSer.uId}', isEqualTo: true)
        .get();
    if (snapshot.docs.isNotEmpty) {
      // Mean chat room exist
      print('Chat Room Already Created');
      var docData=snapshot.docs[0].data();
      ChatRoomModel existingChatRoom=ChatRoomModel.fromMap(docData as Map<String , dynamic>);
         chatRoom = existingChatRoom;
    } else {
      // Mean chat room Does not exist than we create new one
      ChatRoomModel newChatRoom=ChatRoomModel(
        chatRoomId: uuid.v1(),
        lastMessage: '',
        participants: {
          widget.userModel.uId.toString():true,
          targetUSer.uId.toString():true,
        }
      );
      await FirebaseFirestore.instance.collection('chatrooms').doc(newChatRoom.chatRoomId).set(
        newChatRoom.toMap()
      );
      chatRoom = newChatRoom;

      print('New Chat Room Created');

    }
    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                ),
              ),
              const SizedBox(height: 20),
              CupertinoButton(
                color: Colors.blue,
                child: const Text('Search'),
                onPressed: () {
                  setState(() {});
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('email', isEqualTo: searchController.text)
                    .where('email', isNotEqualTo: widget.userModel.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      // fetching from firebase
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      // if(dataSnapshot.docs.length >0){
                      if (dataSnapshot.docs.length>0) {
                        //store in UserMap as  as Map<String , dynamic>;
                        Map<String, dynamic> userMap =
                            dataSnapshot.docs[0].data() as Map<String, dynamic>;
                        // assign to our UserModel
                        UserModel searchedUser = UserModel.fromMap(userMap);
                        return ListTile(
                          onTap: () async {
                            ChatRoomModel? chatRoomModel =
                                await getChatRoomModel(searchedUser);
                            if(chatRoomModel !=null){
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ChatRoom(
                                      firebaseUser: widget.firebaseUser,
                                      targetuser: searchedUser,
                                      userModel: widget.userModel,
                                      chatRoom: chatRoomModel,
                                    );
                                  }
                                ),
                              );
                            }

                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(searchedUser.profilePicture!),
                            backgroundColor: Colors.grey[300],
                          ),
                          title: Text(searchedUser.fullName!),
                          subtitle: Text(searchedUser.email!),
                          trailing: const Icon(Icons.keyboard_arrow_right),
                        );
                      } else {
                        return const Center(child: Text('No Result found!'));
                      }
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('An Error occurred!'));
                    } else {
                      // snapshot is empty
                      return const Center(child: Text('No Result found!'));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
