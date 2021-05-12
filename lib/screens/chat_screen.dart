import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
ScrollController _controller = new ScrollController();
User loggedInUser;
final messageController = TextEditingController();

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;


  String messageText;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

 // void messagesStream() async {
 //    await for (var snapshot in _firestore.collection('messages').snapshots()) {
 //      for (var message in snapshot.docs) {
 //        //print(message.data());
 //      }
 //    }
 //  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                //messagesStream();
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(

                    child: TextField(
                      controller: messageController ,
                      style: TextStyle(
                        color: Colors.black54
                      ),
                      onChanged: (value) {

                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(

                    onPressed: () { 
                      Timer(Duration(milliseconds: 300),()=> _controller.jumpTo(_controller.position.maxScrollExtent));

                      messageController.clear();
                      _firestore.collection('messages').add(
                          {'text': messageText, 'sender': loggedInUser.email});
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender,this.message,this.isMe});
  final String sender;
  final String message;
  final bool isMe;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [ !isMe ? Text('$sender') : Text(''),
          Material(

            borderRadius: isMe ? BorderRadius.only(topLeft : Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0) ) :
                BorderRadius.only(topRight: Radius.circular(30.0),bottomRight: Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0))



            ,
          elevation: 5.0,
          color: isMe ? Colors.blueAccent : Colors.lightBlue ,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0 ),
                child: Text('$message',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.white
                ),)
            )
        ),
      ]
      ),
    )
    ;
  }
}
class MessageStream extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ));
        }
        final messages = snapshot.data.docs.reversed;

        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.get('text');
          final messageSender = message.get('sender');
          final currentUser = loggedInUser.email;
          final messageBubble = MessageBubble(
            sender: messageSender,
            message: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            controller: _controller,
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

