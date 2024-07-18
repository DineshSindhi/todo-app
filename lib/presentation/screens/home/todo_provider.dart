
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/data/model/todo_model.dart';
class TodoProvider extends ChangeNotifier{
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseAuth fireBaseAuth= FirebaseAuth.instance;
  late CollectionReference mTodos;
  List<TodoModel>todoList=[];

  Future<void> addTodo(TodoModel todoModel) async {
    mTodos = fireStore.collection('users').doc(fireBaseAuth.currentUser!.uid).collection('todos');
    mTodos.add(todoModel.toDoc());
    QuerySnapshot<Object?>data= await mTodos.get();
    List<TodoModel>mList=[];
    for(QueryDocumentSnapshot eachTodo in data.docs){
      mList.add(TodoModel.fromDoc(eachTodo.data() as Map<String,dynamic>));
    }
    todoList=mList;
    notifyListeners();
  }
  fecTodo(String uid) async {
    mTodos = fireStore.collection('users').doc(fireBaseAuth.currentUser!.uid).collection('todos');
   QuerySnapshot<Object?>data= await mTodos.get();
   List<TodoModel>mList=[];
   for(QueryDocumentSnapshot eachTodo in data.docs){
     mList.add(TodoModel.fromDoc(eachTodo.data() as Map<String,dynamic>));
   }
   todoList=mList;
   notifyListeners();
  }
 updateTodo(TodoModel todoModel,String id){
    mTodos.doc(id).update(todoModel.toDoc());
    notifyListeners();
 }
 deleteTodo(String id){
    mTodos.doc(id).delete();
    notifyListeners();
 }
}