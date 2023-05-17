import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:upload_property/authenthication/login.dart';
import 'package:upload_property/my_properties/mian_page.dart';
import 'package:upload_property/my_properties/my_properties.dart';

import '../splash_page.dart';



class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return   MainPage();
          } else {
            return const LoginPage();
          }
        } else if (snapshot.hasError) {
          return const Text('Error Occured');
        }
        return  const SplashScreen();
      },
    );
  }
}
