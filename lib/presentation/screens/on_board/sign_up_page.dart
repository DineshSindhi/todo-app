import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/model/user_model.dart';
import '../../../domain/ui_helper.dart';

class SignPage extends StatelessWidget {
  var emailController=TextEditingController();
  var passController=TextEditingController();
  var nameController=TextEditingController();
  var mobController=TextEditingController();
  var genderController=TextEditingController();
  FirebaseAuth fireBaseAuth= FirebaseAuth.instance;
  FirebaseFirestore fireStore =FirebaseFirestore.instance;
  late CollectionReference mUsers;
  @override
  Widget build(BuildContext context) {
    mUsers=fireStore.collection('users');
    return Scaffold(
      appBar: myAppBar('Sign Page'),
      body: Padding(
        padding: const EdgeInsets.only(left: 10,right: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create Account',style: TextStyle(fontSize: 30,)),
            mySizeBox(),
            myTextFiled(controllerName: nameController, label: 'Name',hint: 'Enter your Name'),
            mySizeBox(),
            myTextFiled(controllerName: mobController, label: 'Mobile Number',hint: 'Enter your Mobile Number',keyboardType: TextInputType.number,),
            mySizeBox(),
            myTextFiled(controllerName: genderController, label: 'Gender',hint: 'Enter your Gender',),
            mySizeBox(),
            myTextFiled(controllerName: emailController, label: 'Email',hint: 'Enter your Email',),
            mySizeBox(),
            myPassController(controllerName: passController, label: 'Password',hint: 'Enter your Password'),
            //myTextFiled(controllerName: passController, label: 'Password',hint: 'Enter your Password',suffixIcon: Icon(Icons.visibility_off),obscureText: true),
            mySizeBox(),
            Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: () async {
                try{
                  var cred =await fireBaseAuth.createUserWithEmailAndPassword(email: emailController.text.toString(), password: passController.text.toString());
                 var data= UserModel(email: emailController.text.toString(),
                      pass: passController.text.toString(),
                      uid: cred.user!.uid,
                      mob: mobController.text.toString(),
                      gender: genderController.text.toString(),
                      name: nameController.text.toString());
                 mUsers.doc(cred.user!.uid).set(data.toDoc());
                 print('Sign ${cred.user!.uid}');

                  Navigator.pop(context);
                }on FirebaseAuthException catch(e){
                  if (e.code == 'weak-password') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code)));
                    print('The account already exists for that email.');
                  }
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
                }

              }, child: Text('Sign Up',style: TextStyle(fontSize: 25,color: Colors.white),),style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,),),
            ),
            mySizeBox(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an Account,',style: TextStyle(fontSize: 20,color: Colors.purple.shade600),),
                InkWell(onTap: (){
                  Navigator.pop(context);
                },
                    child: Text(' Login now',style: TextStyle(fontSize: 21,color: Colors.blue),)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}