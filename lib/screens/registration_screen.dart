import 'package:flash_chat/components/RoundButton.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool spinning = false;
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: spinning,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.black
                  ),
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                  obscureText: true,
                  style: TextStyle(
                      color: Colors.black
                  ),
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration
              ),
              SizedBox(
                height: 24.0,
              ),
             RoundButton(title: 'Register',color: Colors.blueAccent,
               onPress: () async{
                 setState(() {
                   spinning = true;
                 });
               try{

               final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
               if(newUser !=null){
                 Navigator.pushNamed(context, 'chat_screen');
               }
               setState(() {
                 spinning = false;
               });

               }
               catch(e){
                 print(e);
               }
             },)
            ],
          ),
        ),
      ),
    );
  }
}
