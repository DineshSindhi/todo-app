
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/presentation/screens/home/photo.dart';
import 'package:todo_app/presentation/screens/home/profile_page.dart';
import 'package:todo_app/presentation/screens/home/todo_page.dart';
class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget>PageList=[
    TodoPage(),
    ProfilePage(),
    PhotoPage()
  ];
  int selected=0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(

        indicatorShape:  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11)
        ),

        indicatorColor: Colors.red,
        backgroundColor: Colors.blueGrey.shade200,
        selectedIndex: selected,


        onDestinationSelected: (value){
          selected=value;
          setState(() {

          });
        },
        destinations: [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home',),
          NavigationDestination(icon: Icon(Icons.account_circle), label: 'Profile',),
          NavigationDestination(icon: Icon(Icons.photo), label: 'Photo',),

  ]),
      body: PageList[selected],

    );

  }
}