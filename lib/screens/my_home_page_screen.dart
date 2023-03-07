
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:khuwari_user_app/screens/select_type_screen.dart';

import '../notificationservice/local_notification_service.dart';
import 'notifiaction_send_screen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final database =  FirebaseDatabase.instance.ref();

  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<void> getDeviceTokenToSendNotification() async {
    final FirebaseMessaging _fcm = FirebaseMessaging.instance;
    final token = await _fcm.getToken();

  }

  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  @override
  Widget build(BuildContext context) {
    getDeviceTokenToSendNotification();
     return MyDrawer();
  }

  Widget MyDrawer(){
    return AdvancedDrawer(
      backdropColor: Color(0xff6B8E23),
      controller: _advancedDrawerController,
      animationCurve: Curves.bounceOut,
      animationDuration: const Duration(milliseconds: 1000),
      animateChildDecoration: true,
      rtlOpening: false,

      disabledGestures: false,
      childDecoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      drawer: SafeArea(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 128.0,
                height: 128.0,
                margin: const EdgeInsets.only(
                  top: 24.0,
                  bottom: 64.0,
                ),
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: Colors.black26,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.school_outlined, size: 60,color: Colors.white,)
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.home),
                title: const Text('Home'),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationSend(),));
                },
                leading: const Icon(Icons.upload),
                title: const Text('Notification'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.favorite),
                title: const Text('Favourites'),
              ),
              ListTile(
                onTap: () {},
                leading: const Icon(Icons.settings),
                title: const Text('Settings')
              ),
              const Spacer(),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white54,
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: const Text('Unknown Developer'),
                ),
              ),
            ],
          ),
        ),
      ),
      child: MainScreenScaffold()
    );
  }

  Widget MainScreenScaffold(){
    return Scaffold(
      appBar: AppBar(
        title: Container(margin: EdgeInsets.symmetric(horizontal: 70),child: Text('BSCS',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),)),
        leading: IconButton(
          onPressed: _handleMenuButtonPressed,
          icon: ValueListenableBuilder<AdvancedDrawerValue>(
            valueListenable: _advancedDrawerController,
            builder: (_, value, __) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
                child: Icon(
                  value.visible ? Icons.clear : Icons.menu,
                  key: ValueKey<bool>(value.visible),
                ),
              );
            },
          ),
        ),
      ),
      backgroundColor: Color(0xff6B8E23),
      body: StreamBuilder(
        stream: database.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data!.snapshot.children.toList();
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (
                        context) =>
                        SelectTypeScreen(semester: list[index]
                            .child('semester')
                            .value as String,)));
                  },
                  child: Container(
                    padding: EdgeInsets.all(3),
                    child: Card(
                      elevation: 5,
                      shape: Border(top: BorderSide.merge(BorderSide(color: Colors.green,width: 20), BorderSide.none)),
                      color: Color(0xff006400),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [Text(
                            list[index]
                                .child('semester')
                                .value as String,
                            style: const TextStyle(
                              fontFamily: 'ShantellSans',
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),),
                            const Text('Semester', style: TextStyle(
                                fontFamily: 'ShantellSans',
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold))
                          ]
                      ),
                    ),
                  ),
                );
              },);
          }
          else {
            return StreamBuilder<ConnectivityResult>(
                stream: Connectivity().onConnectivityChanged,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else {
                    return const Center(child: Icon(Icons
                        .signal_wifi_statusbar_connected_no_internet_4_outlined,
                      size: 200, color: Colors.white,));
                  }
                }
            );
          }
        },
      ),
    );
  }
}
