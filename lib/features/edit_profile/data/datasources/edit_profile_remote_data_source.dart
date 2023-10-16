import 'package:final_nuntius/core/firebase/firebase_helper.dart';

abstract class EditProfileRemoteDataSource {
  Future<void> updateProfileData({required Map<String, dynamic> data});
}

class EditProfileRemoteDataSourceImpl implements EditProfileRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  EditProfileRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Future<void> updateProfileData({required Map<String, dynamic> data}) {
    return firebaseHelper.updateProfileData(data: data);
  }
}
