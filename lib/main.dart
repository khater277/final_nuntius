import 'package:final_nuntius/app/app.dart';
import 'package:final_nuntius/app/bloc_observer.dart';
import 'package:final_nuntius/app/injector.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  final user = HiveHelper.getAllUsers();
  //     .firstWhereOrNull((element) => element.uId == message.data['senderID']);
  // final name = user   == null ? message.data['phoneNumber'] : user.name!;

  print("Handling a background message from : $user");
}

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final x = await FirebaseMessaging.instance.getToken();
  print(x);
  await SharedPrefHelper.init();
  await HiveHelper.init();
  await Permission.contacts.request();

  setupGetIt();
  Bloc.observer = MyBlocObserver();
  tz.initializeTimeZones();
  NotificationsHelper.init();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}
