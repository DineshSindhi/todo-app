
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/presentation/screens/home/home_page.dart';
import 'package:todo_app/presentation/screens/on_board/sign_up_page.dart';

import '../../../domain/ui_helper.dart';
import '../home/todo_page.dart';

class LoginPage extends StatelessWidget {
  var emailController=TextEditingController();
  var passController=TextEditingController();
 FirebaseAuth fireBaseAuth= FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Login Page'),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome to Todos',style: TextStyle(fontSize: 30,)),
            mySizeBox(),
            myTextFiled(controllerName: emailController, label: 'Email',hint: 'Enter your Email'),
            mySizeBox(),
            myPassController(controllerName: passController, label: 'Password',hint: 'Enter your Password'),
            //myTextFiled(controllerName: passController, label: 'Password',hint: 'Enter your Password',suffixIcon: Icon(Icons.visibility_off),obscureText: true),
            mySizeBox(),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () async {
                if(emailController.text.isNotEmpty&&passController.text.isNotEmpty){
                  try{
                    var value=await fireBaseAuth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passController.text.toString());
                   // print('email ${value.user!.uid}');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
                    var pref=await SharedPreferences.getInstance();
                    pref.setString('uId', value.user!.uid);
                  }on FirebaseAuthException catch(e){
                    if (e.code == 'user-not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));

                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Wrong-password')));

                      print('Wrong password provided for that user.');
                    }
                  }catch(e){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));

                  }
                }else{

                }


              }, child: Text('Login',style: TextStyle(fontSize: 25,color: Colors.white),),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
              )),
            ),
            mySizeBox(),
             Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New User? ',style: TextStyle(fontSize: 20,color: Colors.purple.shade600),),
                    InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignPage(),));
                    },
                      child: Text('Create Account now',style: TextStyle(fontSize: 21,color: Colors.blue),)),
                  ],
                ),

          ],
        ),
      ),
    );
  }
}