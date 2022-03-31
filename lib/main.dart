import 'package:flutter/material.dart';
import 'package:linkendin/services/auth.dart';
import 'package:linkendin/services/firebase_data_service.dart';
import 'package:linkendin/view/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'models/firebase_custom_user.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => FirebaseDataService()),
        StreamProvider<FirebaseCustomUser>(create: (context) => AuthService().getChatUser,initialData: FirebaseCustomUser(uid: null),),
      ],
      child: MaterialApp(
        title: 'Assessment',

        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
      ),
    );
  }
}

