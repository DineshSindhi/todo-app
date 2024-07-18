
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
class PhotoPage extends StatefulWidget {
  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  FirebaseFirestore fireStore =FirebaseFirestore.instance;

  FirebaseAuth firebase= FirebaseAuth.instance;

  late CollectionReference mImage;

  File? actualImage;

  @override
  Widget build(BuildContext context) {
    mImage=fireStore.collection('users').doc(firebase.currentUser!.uid).collection('Image');
    return Scaffold(
      appBar: AppBar(title: Text('Photo'),centerTitle: true,backgroundColor: Colors.blueGrey,),
      body: Column(children: [
        InkWell(
          onTap: () async {
            var image= ImagePicker();
            XFile? pickImage=await image.pickImage(source: ImageSource.camera);
            if(pickImage!=null){
             var  cropImage=await ImageCropper().cropImage(sourcePath: pickImage.path,
               uiSettings: [
                 AndroidUiSettings(
                   toolbarTitle: 'Cropper',
                   toolbarColor: Colors.deepOrange,
                   toolbarWidgetColor: Colors.white,
                   aspectRatioPresets: [
                     CropAspectRatioPreset.original,
                     CropAspectRatioPreset.square,
                     CropAspectRatioPreset.ratio16x9,

                   ],
                 ),
                 IOSUiSettings(
                   title: 'Cropper',
                   aspectRatioPresets: [
                     CropAspectRatioPreset.original,
                     CropAspectRatioPreset.square,
                      // IMPORTANT: iOS supports only one custom aspect ratio in preset list
                   ],
                 ),
                 WebUiSettings(
                   context: context,
                 ),
               ],
             );
             actualImage=File(cropImage!.path);
             setState(() {

             });

            }

          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: actualImage!=null?
              DecorationImage(
                image: FileImage(actualImage!),fit: BoxFit.fill
              ):
              DecorationImage(
                image: AssetImage('assets/images/avatar.png',),
              ),
            ),
          ),
        ),
        ElevatedButton(onPressed: (){
          var time=DateTime.now().millisecondsSinceEpoch;
          var image=FirebaseStorage.instance.ref().child('images/profile_pic/IMG_$time.jpg');
          image.putFile(actualImage!).then((value) async {
           var imgUrl=await value.ref.getDownloadURL();
           fireStore.collection('users').doc(firebase.currentUser!.uid).update({
                 'image':imgUrl,
               });
           mImage.add({
             'Image':imgUrl,
             'create':time
           });
          });


        }, child: Text('Upload')),
        Expanded(
          child: StreamBuilder(
            stream: fireStore.collection('users').doc(firebase.currentUser!.uid).collection('Image').snapshots(),
            builder: (_, snapshot){
              if(snapshot.connectionState==ConnectionState.waiting){
                return Center(child: CircularProgressIndicator(),);
              }else if(snapshot.hasError){
                return Center(child:Text('${snapshot.error}'),);
              }else if(snapshot.hasData){
                return snapshot.data!.docs.isNotEmpty?
                GridView.builder(
                  itemCount:snapshot.data!.size,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3
                  ), itemBuilder: (context, index) {
                  var mData=snapshot.data!.docs[index].data();
                  return Container(
                    margin: EdgeInsets.all(7),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage('${mData['Image']}'),fit: BoxFit.fill,
                      )
                    ),
                  );
                },)
                    :Center(child: Text('No Profile photo'),);
              }
              return Container();
            },
          ),
        ),
      ],
      ),
    );}}