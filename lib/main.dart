import 'package:final_nuntius/app/app.dart';
import 'package:final_nuntius/app/bloc_observer.dart';
import 'package:final_nuntius/app/injector.dart';
import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/core/shared_preferences/shared_pref_helper.dart';
import 'package:final_nuntius/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async {
  WidgetsFlutterBinding();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SharedPrefHelper.init();
  await HiveHelper.init();
  setupGetIt();
  Bloc.observer = MyBlocObserver();
  tz.initializeTimeZones();
  NotificationsHelper.init();
  runApp(const MyApp());
}
