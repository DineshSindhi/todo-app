
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
            myTextFiled(controllerName: passController, label: 'Password',hint: 'Enter your Password',suffixIcon: Icon(Icons.visibility_off),obscureText: true),
            mySizeBox(),
            ElevatedButton(onPressed: () async {
              try{
                var value=await fireBaseAuth.signInWithEmailAndPassword(email: emailController.text.toString(), password: passController.text.toString());
               print('${value.user!.uid}');
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TodoPage(),));
                var pref=await SharedPreferences.getInstance();
                pref.setString('uId', value.user!.uid);
              }on FirebaseAuthException catch(e){
                if (e.code == 'user-not-found') {
                  ScaffoldMessenger(child: SnackBar(content: Text('${e.code}'),),);
                  print('No user found for that email.');
                } else if (e.code == 'wrong-password') {
                  ScaffoldMessenger(child: SnackBar(content: Text('${e.code}'),),);
                  print('Wrong password provided for that user.');
                }
              }catch(e){
                ScaffoldMessenger(child: SnackBar(content: Text('Error :${e}'),),);
              }

            }, child: Text('Login',style: TextStyle(fontSize: 25),),),
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