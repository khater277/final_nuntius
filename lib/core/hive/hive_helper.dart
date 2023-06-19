import 'package:final_nuntius/core/hive/keys.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static Box<UserData?>? userData;

  static Future<void> init() async {
    await Hive.initFlutter();

    /// Adapters
    Hive.registerAdapter(UserDataAdapter());

    /// Open Boxes
    userData = await Hive.openBox(HiveKeys.currentUser);
  }

  /// USER
  static Future<void> setCurrentUser({required UserData? user}) {
    return userData!.put(HiveKeys.currentUser, user);
  }

  static UserData? getCurrentUser() {
    return userData!.get(HiveKeys.currentUser);
  }
}
