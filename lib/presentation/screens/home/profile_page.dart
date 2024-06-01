import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/ui_helper.dart';
import 'package:todo_app/presentation/screens/on_board/login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseFirestore fireStore =FirebaseFirestore.instance;
  @override

  @override
  Widget build(BuildContext context) {
    fireStore.collection('users');
    return Scaffold(
      appBar: myAppBar('ProfilePage'),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          myCon('Name - ', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.edit)),
          myCon('Mobile No. - ', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.edit)),
          myCon('Gender - ', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.edit)),
          myCon('Email - ', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.edit)),
          myCon('Password - ', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.edit)),
          myCon('Sign Out', (){
            final firBaseAuth=FirebaseAuth.instance;
            firBaseAuth.signOut().then((value){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
            },onError: (e){
              print(e);
            });
          }, Icon(Icons.logout)),
        ],
      )
    );
  }

  myCon( String text, VoidCallback? onTap,Icon? icon){
    return Container(
      width: double.infinity,
      height: 70,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange.shade500
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text,style: TextStyle(fontSize: 20),),
            InkWell(
                onTap: onTap,
                child: icon)
          ],
        ),
      ),
    );
  }
}
//  Expanded(
//             child: StreamBuilder(
//               stream: fireStore.collection('users').snapshots(),
//               builder: (_, snapshot){
//                 if(snapshot.connectionState==ConnectionState.waiting){
//                   return Center(child: CircularProgressIndicator(),);
//                 }else if(snapshot.hasError){
//                   return Center(child:Text('${snapshot.error}'),);
//                 }else if(snapshot.hasData){
//                   return ListView.builder(
//                     itemCount: snapshot.data!.size,
//                     itemBuilder: (context, index) {
//                       var mData=snapshot.data!.docs[index].data();
//                       var eachData=UserModel.fromDoc(mData);
//                       return Column(
//                         children: [
//                           //Text('${eachData}'),
//                         ],
//                       )
//                       ;},);
//                 }
//                 return Container();
//               },
//             ),
//           ),
