import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rentit4me/blocs/network_bloc/network_bloc.dart';
import 'package:rentit4me/views/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyD95hWitzb33vCW0NEoaIEo0pFlF0jhvTU",
        authDomain: "rentit4me-fa859.firebaseapp.com",
        projectId: "rentit4me-fa859",
        storageBucket: "rentit4me-fa859.appspot.com",
        messagingSenderId: "699757287064",
        appId: "1:699757287064:web:692995a3ecfb4a1aef22ed",
        measurementId: "G-DWTM6MRTWS")
  );
 
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InternetBloc(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          //theme: lightThemeData(context),
          //darkTheme: darkThemeData(context),
          title: 'Rentit4me',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
          ),
           home: SplashScreen()
          //home: PersonalDetailScreen(),
          //home: SignupConsumerScreen(),
          //home: SignupScreen(),
          //home: const CurrentUserLocationScreen(),
      ),
    );
  }
}
