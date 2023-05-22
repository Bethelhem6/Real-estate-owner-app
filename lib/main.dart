import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:upload_property/authenthication/auth_screen.dart';
import 'package:upload_property/my_properties/mian_page.dart';
import 'package:upload_property/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Companies app',
      theme: ThemeData(
        primaryColor: Colors.teal,
      ),
      home: const AuthStateScreen(),
    );
  }
}
