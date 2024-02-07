import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:noti_app/firebase_options.dart';
import 'package:noti_app/notificationservice/local_notification_service.dart';
import 'package:noti_app/screens/home_screen.dart';

//start firebase background services
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //find the device token
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  FirebaseMessaging.instance
      .requestPermission(alert: true, sound: true, badge: true);
  final fcmToken = await fcm.getToken();
  print(fcmToken);
  log("FCM Token: $fcmToken");
  //call the backgroundHandler function
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  LocalNotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
