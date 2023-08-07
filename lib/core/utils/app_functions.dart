import 'package:final_nuntius/core/hive/hive_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';

class AppFunctions {
  static String? handleTextFieldValidator({
    required List<bool> conditions,
    required List<String> messages,
  }) {
    String? result;
    for (int i = 0; i < conditions.length; i++) {
      if (conditions[i]) {
        result = messages[i];
      }
      if (result != null) break;
    }
    return result;
  }

  static String generateCountryFlag({required String countryCode}) {
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));

    return flag;
  }

  static Map<String, dynamic> getFcmBody({required UserData user}) {
    late String name;
    try {
      name = user.contacts![HiveHelper.getCurrentUser()!.phone!]!;
    } catch (error) {
      name = HiveHelper.getCurrentUser()!.phone!;
    }
    return {
      "to": user.token!,
      "priority": "high",
      "notification": {
        "title": "New Message",
        "body": "$name sent you new message",
        "sound": "default"
      },
      "data": {
        "type": "message",
        "id":
            "${HiveHelper.getCurrentUser()!.uId!}${user.uId!}${DateTime.now().millisecondsSinceEpoch}",
        "senderID": HiveHelper.getCurrentUser()!.uId!,
        "phoneNumber": HiveHelper.getCurrentUser()!.phone!,
        "click_action": "FLUTTER_NOTIFICATION_CLICK"
      }
    };
  }

  static String storyDate(String date) {
    String? finalDate;
    DateTime storyDate = DateTime.parse(date);
    DateTime nowDate = DateTime.now();

    int minutesDiff = nowDate.difference(storyDate).inMinutes;
    if (minutesDiff >= 60) {
      finalDate =
          "${(minutesDiff / 60).floor()} ${(minutesDiff / 60).floor() == 1 ? "hour" : "hours"} ago";
    } else {
      if (minutesDiff == 0) {
        finalDate = "just now";
      } else {
        finalDate =
            "$minutesDiff ${minutesDiff == 1 ? "minute" : "minutes"} ago";
      }
    }

    return finalDate;
  }

  static Duration durationParser({required String duration}) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = duration.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }
}
