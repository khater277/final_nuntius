import 'package:final_nuntius/core/hive/keys.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static Box<UserData?>? userData;
  static Box<UserData>? allUsers;

  static Future<void> init() async {
    await Hive.initFlutter();

    /// Adapters
    Hive.registerAdapter(UserDataAdapter());

    /// Open Boxes
    userData = await Hive.openBox(HiveKeys.currentUser);
    allUsers = await Hive.openBox(HiveKeys.allUsers);
  }

  /// CURRENT USER
  static Future<void> setCurrentUser({required UserData? user}) {
    return userData!.put(HiveKeys.currentUser, user);
  }

  static UserData? getCurrentUser() {
    return userData!.get(HiveKeys.currentUser);
  }

  /// ALL USERS
  static Future<void> setAllUsers({required List<UserData> users}) async {
    for (var element in users) {
      allUsers!.put(element.phone, element);
    }
  }

  static List<UserData>? getAllUsers() {
    List<UserData>? result;
    if (allUsers!.isNotEmpty) {
      result = [];
      for (int i = 0; i < allUsers!.length; i++) {
        result.add(allUsers!.getAt(i)!);
      }
    }
    return result;
  }
}
