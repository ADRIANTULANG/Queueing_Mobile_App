import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:queuing_system/Variables/color.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:queuing_system/Variables/global.dart';
import 'Pages/RootPage.dart';
import 'Variables/global.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // myUserDetails.addListener(() {
    //   setState(() {});
    // });
    // initializeFirebase();
    initializedNotificationChannels();
    super.initState();
  }

  initializedNotificationChannels() async {
    getToken();
    await notificationSetup();
    await onBackgroundMessage();
    await onForegroundMessage();
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  getToken() async {
    final box = GetStorage();
    var generatedToken = await messaging.getToken();
    token = generatedToken;
    box.write("fcmToken", generatedToken);
    print('Generated device token: $generatedToken');
  }

  notificationSetup() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          importance: NotificationImportance.High,
        ),
        NotificationChannel(
          channelKey: 'basic_channel_muted',
          channelName: 'Basic muted notifications ',
          channelDescription: 'Notification channel for muted basic tests',
          importance: NotificationImportance.High,
          playSound: false,
        )
      ],
    );
  }

  onForegroundMessage() async {
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');

          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: Random().nextInt(9999),
              channelKey: 'basic_channel_muted',
              title: '${message.notification.title.toString()}',
              body: '${message.notification.body.toString()}',
              notificationLayout: NotificationLayout.BigText,
            ),
          );
          ;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: RootPage(),
      theme: ThemeData(
        primaryColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(
              fontSize: 14.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              color: secondaryColor),
          bodyMedium: TextStyle(
              fontSize: 12.0,
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              color: primaryColor),
          labelLarge: TextStyle(
            fontSize: 18.0,
            fontFamily: 'Lato',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

onBackgroundMessage() async {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: Random().nextInt(9999),
        channelKey: 'basic_channel_muted',
        title: '${message.notification.title.toString()}',
        body: '${message.notification.body.toString()}',
        notificationLayout: NotificationLayout.BigText,
      ),
    );
  }
}
