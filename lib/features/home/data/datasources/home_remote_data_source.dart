import 'package:final_nuntius/core/firebase/firebase_helper.dart';
import 'package:final_nuntius/features/auth/data/models/user_data/user_data.dart';

abstract class HomeRemoteDataSource {
  Future<List<UserData>?> getAllUsersFromFirestore();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  HomeRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Future<List<UserData>?> getAllUsersFromFirestore() {
    return firebaseHelper.getAllUsersFromFirestore();
  }
}
