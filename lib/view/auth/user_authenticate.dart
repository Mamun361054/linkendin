import 'package:flutter/material.dart';
import 'package:linkendin/view/auth/sign_in.dart';
import 'package:linkendin/view/auth/sign_up.dart';

class UserAuthenticate extends StatefulWidget {

  const UserAuthenticate({Key? key}) : super(key: key);

  @override
  _UserAuthenticateState createState() => _UserAuthenticateState();
}

class _UserAuthenticateState extends State<UserAuthenticate> {
  bool showSignIn = true;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !showSignIn ? UserSignUp(toggleView: toggleView,):UserSignIn(toggleView: toggleView),
    );
  }
}
