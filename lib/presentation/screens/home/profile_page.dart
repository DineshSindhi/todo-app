import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/model/user_model.dart';
import 'package:todo_app/domain/ui_helper.dart';
import 'package:todo_app/presentation/screens/on_board/login_page.dart';

class ProfilePage extends StatelessWidget {
  FirebaseFirestore fireStore =FirebaseFirestore.instance;
  var controller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    fireStore.collection('users');
    return Scaffold(
      appBar: myAppBar('ProfilePage'),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          myContainer('Name - ', (){
            showModalBottomSheet(context: context, builder: (c) {
              return mySheet('Name', 'Name','Update Name',context);
            },);
          }, Icon(Icons.edit)),
          myContainer('Mobile No. - ', (){
            showModalBottomSheet(context: context, builder: (c) {
              return mySheet('Mobile No.', 'Mobile No.', 'Update Mobile No.',context);
            },);
          }, Icon(Icons.edit)),
          myContainer('Gender - ', (){
            showModalBottomSheet(context: context, builder: (c) {
              return mySheet('Gender', 'Gender', 'Update Gender',context);
            },);
          }, Icon(Icons.edit)),
          myEmail('Email - '),
          myContainer('Password - ', (){
            showModalBottomSheet(context: context, builder: (c) {
              return mySheet('Password', 'Password', ' Update Password',context);
            },);
          }, Icon(Icons.edit)),
          myContainer('Sign Out', (){
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

  myContainer( String text, VoidCallback? onTap,Icon? icon){
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
  Widget mySheet(String titleText, String lable,String buttonText, BuildContext context ) {
    return Container(
        height: 300,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              Text(titleText,style: TextStyle(fontSize: 30,color: Colors.white),),
              SizedBox(height: 10,),
              TextField(controller: controller,
                decoration: InputDecoration(
                    label: Text(lable),
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text(buttonText,style: TextStyle(color: Colors.white,fontSize: 20),),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,)),
                  ElevatedButton(onPressed: (){
                    Navigator.pop(context);
                  }, child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 22),),style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,)),
                ],
              )
            ])));
}}
myEmail(String text){
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
      child: Row(
        children: [
          Text(text,style: TextStyle(fontSize: 20),),
        ],
      ),
    ),
  );
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
