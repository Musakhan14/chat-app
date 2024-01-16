// ignore_for_file: unnecessary_null_comparison

import 'package:chat_appp/main.dart';
import 'package:chat_appp/models/chat_room_model.dart';
import 'package:chat_appp/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class ChatRoom extends StatefulWidget {
  final UserModel targetuser;
  final ChatRoomModel chatRoom;
  final UserModel userModel;
  final User firebaseUser;

  const ChatRoom(
      {super.key,
      required this.targetuser,
      required this.chatRoom,
      required this.userModel,
      required this.firebaseUser});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  void sendMessage() async {
    String msg = messageController.text.trim();
    messageController.clear();
    if (msg != null) {
      MessageModel newMessage = MessageModel(
        createdOn: DateTime.now(),
        messageId: uuid.v1(),
        seen: false,
        text: msg,
        sender: widget.userModel.uId,
      );
      FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(widget.chatRoom.chatRoomId)
          .collection('messages')
          .doc(newMessage.messageId)
          .set(newMessage.toMap());
      print('Message Sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    NetworkImage(widget.targetuser.profilePicture.toString()),
              ),
              const SizedBox(width: 10),
              Text(widget.targetuser.fullName.toString())
            ],
          ),
        ),
        body: Column(
          children: [
            //Chat will go here
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(widget.chatRoom.chatRoomId)
                    .collection('messages')
                    .orderBy('createdOn', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot dataSnapshot =
                          snapshot.data as QuerySnapshot;
                      return ListView.builder(
                          reverse: true,
                          itemCount: dataSnapshot.docs.length,
                          itemBuilder: (context, index) {
                            MessageModel currentMessage = MessageModel.fromMap(
                                dataSnapshot.docs[index].data()
                                    as Map<String, dynamic>);
                            return Row(
                              mainAxisAlignment: (currentMessage.sender ==
                                      widget.userModel.uId)
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    color: (currentMessage.sender ==
                                            widget.userModel.uId)
                                        ? Colors.grey
                                        : Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    currentMessage.text.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            );
                          });
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Please Check Your Internet Connection'),
                      );
                    } else {
                      return const Center(
                        child: Text('Say Hi to Your Friend'),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )),

            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                children: [
                  Flexible(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Message',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
