import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:khuwari_user_app/Services/toast.dart';
import 'package:khuwari_user_app/screens/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SlidesScreen extends StatefulWidget {
  final query;
  final name;
  final id; // id is mid or final
  const SlidesScreen({super.key,
    required this.query,
    required this.name,
    required this.id
  });
  @override
  State<SlidesScreen> createState() => _SlidesScreenState(query : query, name : name, id: id);
}
class _SlidesScreenState extends State<SlidesScreen> {
  final query;
  final name;
  final id;
  _SlidesScreenState({this.query, this.name, this.id});

  bool loading = false;
  final Dio dio = Dio();
  double progress = 0.0;
  Future<bool> saveFile(String url, String fileName) async {
    Directory directory ;
    List<String> folder;
    try{
      if(await permissionCheck(Permission.storage)){
        directory = (await getExternalStorageDirectory())!;
        // folder = directory.path.split('Android');
        // print(folder[0]);
      }
      else{
        return false;
      }
      if(!await directory.exists()){
        await directory.create(recursive: true);
      }
      if(await directory.exists()){
        var path = '${directory.path}/$fileName.pdf';
        bool check = true;
        await dio.download(url, path)
            .onError((error, stackTrace) {
          check = false;
          Toast().show(error.toString());
          return Future.error(error!);
        });
        return check;
      }
    }catch(e){
      print(e);
    }
    return false;
  }
  Future<bool> permissionCheck(Permission permission) async{
    if(await permission.isGranted){
      return true;
    }
    else{
      var result = await permission.request();
      if(result !=  PermissionStatus.granted){
        Toast().show('Permission Granted');
        return true;
      }
      else{
        Toast().show('Permission Denied');
        return false;
      }
    }

  }
  downloadFile(String url, String fileName) async {
    setState(() {loading = true;});
    bool downloaded = await saveFile(url, fileName);
    if(downloaded){
      Toast().show('Downlaoded');
    }else{
      Toast().show('Failed To Download');
    }

    setState(() {loading = false;});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: StreamBuilder(
        stream: query.child(id).onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent>snapshot) {
          if(snapshot.hasData){
            var list = snapshot.data!.snapshot.children.toList();
            return ListView.builder(
              itemCount: list.length-2,
              itemBuilder: (context, index) {
                String path = list[index].child('url').value as String;
                String name = list[index].child('name').value as String;
              //String time = list[index].child('time').value as String;
                return InkWell(
                  onTap: () {
                  },
                  child: Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  SizedBox(width: 8,),
                                  Icon(Icons.picture_as_pdf, size: 50,),
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 2,
                                        height: 100,
                                        color: Colors.white,
                                      ),

                                      Container(
                                        height: 100,
                                        width: 80,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            InkWell(
                                                onTap: (){
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => PDf(path: path, name: name),));
                                                },
                                                child: Icon(Icons.remove_red_eye, color: Colors.white, size: 30,)),
                                            InkWell(
                                                onTap: (){
                                                  downloadFile(path, name);
                                                },
                                                child: Icon(Icons.download, color: Colors.white, size: 30))
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ),
                );
              },);
          }
          else{
            return Center(child: CircularProgressIndicator(),);
          }
        },
      ),
    );
  }
}
