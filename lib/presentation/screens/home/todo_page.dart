import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app/data/model/todo_model.dart';
import 'package:todo_app/domain/ui_helper.dart';

class TodoPage extends StatefulWidget {
  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  var titController = TextEditingController();
  var taskDescController = TextEditingController();
  var dtFor = DateFormat.Hm();
  String? id;
  String? pn;
  String?uId;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  late CollectionReference mTodos;

  @override
  void initState() {
    super.initState();
    getId();
  }

  getId() async {
    var pref = await SharedPreferences.getInstance();
    uId = pref.getString('uId');
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    mTodos = fireStore.collection('users').doc(uId).collection('todos');
    return Scaffold(
      appBar: myAppBar('Todos'),
      body: uId != null ? StreamBuilder(
        stream: fireStore.collection('users').doc(uId)
            .collection('todos').orderBy('createdAt',descending: true)
            .snapshots(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'),);
          } else if (snapshot.hasData) {

            return snapshot.data!.docs.isNotEmpty ? ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var mData = snapshot.data!.docs[index].data();
                var eachData = TodoModel.fromDoc(mData);
                id=snapshot.data!.docs[index].id;
                var pt=eachData.priority;
                return Container(
                  height: 70,
                  width: 400,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey)
                  ),
                  child: ListTile(
                     tileColor: eachData.isCompleted==true?Colors.green:pt=='1'?Colors.red.shade600:pt=='2'?Colors.blue.shade600:pt=='3'?Colors.orange:Colors.white,
                    onLongPress: () {
                      showModalBottomSheet(context: context, builder: (context) {
                        return Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.shade300,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                  InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                        showModalBottomSheet(context: context, builder: (context) {
                                          titController.text = eachData.title!;
                                          taskDescController.text = eachData.taskDesc!;
                                          return mySheet(context: context,
                                              isUpdate: true,
                                              upIndex: snapshot.data!.docs[index].id,
                                              createAtu: eachData.createdAt);

                                        },);
                  
                  
                                      },
                                      child: Icon(Icons.edit,color: Colors.orange,size: 30,)),
                                  InkWell(
                                      onTap: (){
                                        mTodos.doc(snapshot.data!.docs[index].id).delete();
                                        Navigator.pop(context);
                                      },
                                      child: Icon(Icons.delete,color: Colors.orange,size: 30,)),
                                ],)
                              ],),
                            )
                        );;
                      },);
                    },
                    leading: Checkbox(
                      value: eachData.isCompleted,
                      onChanged: (value){
                        eachData.isCompleted==false?
                        mTodos.doc(snapshot.data!.docs[index].id).update({
                          'isCompleted':true,
                          'completedAt':DateTime.now().millisecondsSinceEpoch.toString(),
                        }):mTodos.doc(snapshot.data!.docs[index].id).update({
                          //
                          'isCompleted':false,
                          'completedAt':'',
                        });
                      },
                    ),
                    title: Text('${eachData.title}',style: TextStyle(color: Colors.white,fontSize: 20,
                    decoration:eachData.isCompleted==true? TextDecoration.lineThrough:TextDecoration.none ),),
                    subtitle: Text('${eachData.taskDesc}',style: TextStyle(color: Colors.white,decoration:eachData.isCompleted==true? TextDecoration.lineThrough:TextDecoration.none ),),
                    trailing: Column(
                      children: [
                        Text('${dtFor.format(DateTime.fromMillisecondsSinceEpoch(
                            int.parse(eachData.createdAt.toString())))}',style: TextStyle(color: Colors.white,fontSize: 16,),),

                        Text(eachData.isCompleted==true?
                        '${dtFor.format(DateTime.fromMillisecondsSinceEpoch(int.parse(eachData.completedAt.toString())))}'
                            :''
                          ,style: TextStyle(color: Colors.white,fontSize: 16,),),
                        //raju@gmail.com
                  
                      ],
                    ),
                  ),
                );
              },) : Center(child: Text('No Todo Yet'),);
          }
          return Container();
        },
      ) : Center(child: CircularProgressIndicator(),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) =>
              mySheet(context: context),);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget mySheet(
      {bool isUpdate = false, String upIndex = '', createAtu = '', required BuildContext context}) {
    return Container(
        height: 700,
        decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))
        ),
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(children: [
              Text(isUpdate ? 'Update Todo' : 'Todo',
                style: TextStyle(fontSize: 30,color: Colors.white),),
              TextField(controller: titController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                    label: Text('Enter Title'),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)
                    )
                ),),
              SizedBox(height: 10,),
              TextField(controller: taskDescController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    label: Text('Enter TaskDesc'),
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )
                ),),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text('Priority',style: TextStyle(fontSize: 25,color: Colors.white),),
                    Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(onPressed: () async {
                          pn='1';

                        }, child: Text('High', style: TextStyle(fontSize: 25),)),
                        SizedBox(width: 5,),
                        ElevatedButton(onPressed: () async {
                          pn='2';

                        }, child: Text('Medium', style: TextStyle(fontSize: 25),)),
                        SizedBox(width: 5,),
                        ElevatedButton(onPressed: () async {
                          pn='3';
                        }, child: Text('Low', style: TextStyle(fontSize: 25),)),
                        SizedBox(width: 5,)
                      ],),
                  ],

                ),
              ),
              SizedBox(height: 10,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () async {
                    if(titController.text.isNotEmpty&&taskDescController.text.isNotEmpty){
                      if (isUpdate) {
                        ///update details
                        var upData = TodoModel(
                            title: titController.text.toString(),
                            taskDesc: taskDescController.text.toString(),
                            createdAt: DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString(),
                            priority: pn
                        );
                        mTodos.doc(upIndex).update(upData.toDoc());
                        Navigator.pop(context);
                        titController.clear();
                        taskDescController.clear();

                      } ///Add details
                      else {
                        var data = TodoModel(title: titController.text.toString(),
                            taskDesc: taskDescController.text.toString(),
                            createdAt: DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString(),
                            completedAt: DateTime
                                .now()
                                .millisecondsSinceEpoch
                                .toString(),
                            userId: uId,
                            priority: pn
                        );
                        mTodos.add(data.toDoc());
                        Navigator.pop(context);
                        titController.clear();
                        taskDescController.clear();
                      }
                    }else{

                    }

                  },
                      child: Text(isUpdate ? 'Update Todo' : 'Add Todo',
                        style: TextStyle(fontSize: 25),)),
                  ElevatedButton(onPressed: () {
                    Navigator.pop(context);
                  }, child: Text('Cancel', style: TextStyle(fontSize: 25),)),
                ],
              ),

            ])));
  }

}
