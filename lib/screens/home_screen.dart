import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:noti_app/notificationservice/local_notification_service.dart';
import 'package:noti_app/screens/demo.dart';
import 'package:noti_app/screens/service_test_screen.dart';
import 'package:workmanager/workmanager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // RemoteNotification? sampleNoti = const RemoteNotification(title: "Tech Sales", body: "check check");
  RemoteMessage samplMsg = const RemoteMessage(
      notification:
          RemoteNotification(title: "Tech Sales", body: "check check"));
  //define all the three conditions of app termination, app in foreground and app in background in the init state

  //note: a notification channel is required for displaying handsome notification => this is to be done in the android manifest file inside activity
  @override
  void initState() {
    super.initState();
    //default frequency is 15 minutes and anything below that is set to 15 minutes by default

    /* 1. This method call when app in terminated state and you get a notification
    when you click on notification app open from terminated state and you can get notification data in this method*/

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        print("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          print("New Notification");
          if (message.data['_id'] != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => Demo(
                  id: message.data['_id'],
                ),
              ),
            );
          }
        }
      },
    );

    //2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notification App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                // onPressed: () {
                //   //on Demand background Task
                //   LocalNotificationService.createanddisplaynotification(samplMsg);
                // },
                //task scheduler
                onPressed: () {
                  //on Demand background Task
                  Workmanager().registerOneOffTask("OnlyOneTask", "Single",
                      // constraints: Constraints(networkType: NetworkType.connected),
                      initialDelay: const Duration(seconds: 5));
                },
                child: const Text("Push Notification")),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ServiceTestScreen(title: "Service Page")));
                },
                child: const Text("Service Page")),
          ],
        ),
      ),
    );
  }
}
