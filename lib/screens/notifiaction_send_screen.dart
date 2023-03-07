
import 'package:flutter/material.dart';
import 'package:khuwari_user_app/Widgets/text_field.dart';

import '../Services/local_notification_service.dart';

class NotificationSend extends StatefulWidget {
  const NotificationSend({Key? key}) : super(key: key);

  @override
  State<NotificationSend> createState() => _NotificationSendState();
}

class _NotificationSendState extends State<NotificationSend> {
  late final  LocalNotificationServic service ;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  void initState() {
    service = LocalNotificationServic();
    service.initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification Send"),
      ),
      body:Center(
          child: Container(
            child: Column(
              children: [
                SizedBox(height: 100,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: MyTextField(controller: titleController,
                  hintText: 'Title',),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: MyTextField(controller: descController,
                    hintText: 'Description',),
                ),
                SizedBox(height: 100,),
                ElevatedButton(
                    onPressed: () async{
                     await  service.showNotification(id: 0, title: titleController.text.toString(), body: descController.text.toString());
                    },
                    child: Text('Send Notification', style: TextStyle(color: Colors.white),)),

                // ElevatedButton(
                //   onPressed: (){},
                //   child: Text('Scheduled Notification', style: TextStyle(color: Colors.white)),
                // ),
                //
                // ElevatedButton(
                //   onPressed: (){},
                //   child: Text('Next Screen Notifiacation', style: TextStyle(color: Colors.white)),
                // )
              ],
            ),
          )
      ),
    );
  }
}
