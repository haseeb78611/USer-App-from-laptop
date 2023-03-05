import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:khuwari_user_app/screens/select_type_screen.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final database = FirebaseDatabase.instance.ref();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Work'),
      ),
      body: StreamBuilder(
        stream: database.onValue,
        builder: (context,AsyncSnapshot<DatabaseEvent> snapshot) {
          if(snapshot.hasData) {
            // Map<dynamic, dynamic> map = snapshot.data!.snapshot.children as dynamic;
            // print("33 working ${map.toString()}");
            // List<dynamic> list = [];
            // list.clear();
            // list = map.values.toList();
            var list = snapshot.data!.snapshot.children.toList();
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SelectTypeScreen(semester: list[index].child('semester').value as String,)));
                  },
                  child: Card(
                    color: Colors.blue,
                    child:  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text(
                        list[index].child('semester').value as String,
                        style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),),
                        Text('Semester',  style: TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold))
                  ]
                    ),
                  ),
                );
              }
              ,);
          }
          else{
            return Center(child: CircularProgressIndicator());
          }
              },

      )
    );
  }
}
