import 'package:collection/collection.dart';
import 'package:final_nuntius/config/navigation.dart';
import 'package:final_nuntius/core/local_notifications/local_notifications_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:final_nuntius/features/home/cubit/home_cubit.dart';
import 'package:final_nuntius/features/messages/presentation/screens/messages_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FcmHelper {
  static void handleForegroundNotification({required HomeCubit homeCubit}) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        UserData? userModel = homeCubit.users.firstWhereOrNull(
            (element) => element.uId == message.data['senderID']);
        String? name =
            userModel != null ? userModel.name! : message.data['phoneNumber'];
        int id = (DateTime.now().millisecondsSinceEpoch / 1000).floor();
        print(homeCubit.user);
        // print("asdfghjk");
        if ((homeCubit.user == null) ||
            (homeCubit.user!.uId != message.data['senderID'])) {
          print("asdfghjk");
          NotificationsHelper.showNotification(
              id: id, name: name!, senderID: message.data['senderID']);
        }
      }
    });
  }

  static void handelBackgroundNotification(
      {required HomeCubit homeCubit, required BuildContext context}) {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      debugPrint("sender=================>${message.data['senderID']}");
      UserData? user = homeCubit.users.firstWhereOrNull(
          (element) => element.uId == message.data['senderID']);
      if (user == null) {
        homeCubit.getChats(context);
        user = homeCubit.users.firstWhereOrNull(
            (element) => element.uId == message.data['senderID']);
        Go.to(context: context, screen: MessagesScreen(user: user!));
        // Get.to(() => MessagesScreen(user: user!, isFirstMessage: false));
      } else {
        Go.to(context: context, screen: MessagesScreen(user: user));
        // Get.to(() => MessagesScreen(user: user!, isFirstMessage: false));
      }
    });
  }
}
