import 'package:flutter/material.dart';
import 'package:linkendin/view/auth/user_authenticate.dart';
import 'package:provider/provider.dart';
import '../../models/firebase_custom_user.dart';
import '../home_page/hotelHomeScreen.dart';

class AuthPage extends StatelessWidget {

  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<FirebaseCustomUser>(context);
    return user.uid == null ? UserAuthenticate(): HotelHomeScreen();
    return HotelHomeScreen();
  }
}
