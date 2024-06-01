import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/presentation/screens/home/home_page.dart';
import 'package:todo_app/presentation/screens/home/todo_page.dart';

import '../on_board/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    checkLog();
  }
  checkLog() async {
    final auth=FirebaseAuth.instance;
    final user=auth.currentUser;

    if(user != null){
      print(user);
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => HomePage(),));
      });
    }
    else{
      Timer(Duration(seconds: 2), () {
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginPage(),));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 200,height: 110,
                child: Image.asset('assets/images/logo.png',fit: BoxFit.fill,)),
            Text('Do Your Todos',style: TextStyle(fontSize: 35 ,color: Colors.white),),
          ],
        ),
      ),
    );
  }
}
