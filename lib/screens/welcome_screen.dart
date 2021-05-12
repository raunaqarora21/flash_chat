import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/RoundButton.dart';
import 'package:firebase_core/firebase_core.dart';
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  AnimationController controller;
  Animation animation;
  @override
  void initState() {

    super.initState();

    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,



    );
    controller.forward();
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.addListener(() {setState(() {

    });});

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: animation.value * 100,
                  ),
                ),
                  AnimatedTextKit(
                  animatedTexts : [TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                    speed: const Duration(milliseconds: 200),
                  ),
                  ],
                    totalRepeatCount: 4,

                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(color: Colors.lightBlueAccent, title: 'Log In', onPress:  () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            },),
            RoundButton(title: 'Register',color: Colors.blueAccent, onPress: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
            },),

          ],
        ),
      ),
    );
  }
}

