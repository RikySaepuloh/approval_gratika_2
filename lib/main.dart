import 'package:al_downloader/al_downloader.dart';
import 'package:approval_gratika/constants.dart';
import 'package:approval_gratika/ui/login/splash_screen.dart';
import 'package:approval_gratika/ui/main/main_screen.dart';
import 'package:approval_gratika/ui/login/login_screen.dart';
import 'package:approval_gratika/viewmodel/LoginViewModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';



Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
  // Handle the background message here
}

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      // Handle the notification
      print("Notification Title: ${notification.title}");
      print("Notification Body: ${notification.body}");
      _showNotification(message);
    }
  });
  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: AppColors.primaryColor, // Replace with your desired color
    statusBarBrightness: Brightness
        .dark, // Optional: If you want to set the status bar icons' color (dark or light)
  ));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  // FlutterLocalNotificationsPlugin();

  // Future<void> _showNotification(RemoteMessage message) async {
  //   const AndroidNotificationDetails androidPlatformChannelSpecifics =
  //   AndroidNotificationDetails(
  //     'channel_for_receiving_approval_notification', // Replace with a unique channel ID
  //     'Approval Gratika', // Replace with a channel name
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );
  //
  //   const NotificationDetails platformChannelSpecifics =
  //   NotificationDetails(android: androidPlatformChannelSpecifics);
  //
  //   await flutterLocalNotificationsPlugin.show(
  //     0, // Notification ID
  //     message.notification?.title ?? 'Notification Title', // Title
  //     message.notification?.body ?? 'Notification Body', // Body
  //     platformChannelSpecifics,
  //     payload: 'Custom_Sound', // Optional payload
  //   );
  // }


  @override
  void initState() {
    super.initState();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon'); // Replace with your app's icon name
    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    Future<void> _showNotification(RemoteMessage message) async {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
        'channel_for_receiving_approval_notification', // Replace with a unique channel ID
        'Approval Gratika', // Replace with a channel name
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        message.notification?.title ?? 'Notification Title', // Title
        message.notification?.body ?? 'Notification Body', // Body
        platformChannelSpecifics,
        payload: 'Custom_Sound', // Optional payload
      );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: OverlaySupport(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/login': (context) => LoginScreen(),
            '/main': (context) => MainScreen(),
          },
        ),
      ),
    );
  }
}
