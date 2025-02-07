import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lisifyy/detailed_screen.dart';
import 'package:lisifyy/home_screen.dart';
import 'package:lisifyy/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'signup_page.dart';

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  if(Firebase.apps.isEmpty) {
    try {
      await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: 'AIzaSyCYcHtqmO_rgs8viJaQUowX4CwlatQez0s',
            appId: '1:464843060806:android:3acc36636e68eeeb72bc47',
            messagingSenderId: '464843060806',
            projectId: 'listify-5a9dc'),
      );
    } catch (e) {
      print("Error initializing Firebase : ---------$e");
      return;
    }
    print("Firebase Connection Succcessful");
  }
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('UserId');
  String initialroute =
  (userId != null && userId.isNotEmpty) ? 'HomeScreen' : 'LoginPage';
  runApp(MyApp(initialRoute: initialroute));
}

class MyApp extends StatelessWidget {
   MyApp({super.key, required this.initialRoute});

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initialRoute,
      routes: {
        'HomeScreen' :(context)=> HomeScreen(),
        'LoginPage'  :(context)=>LoginPage()
      },
      //home: SignupPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
