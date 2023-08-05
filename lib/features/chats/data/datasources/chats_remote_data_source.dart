import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_nuntius/core/firebase/firebase_helper.dart';

abstract class ChatsRemoteDataSource {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats();
}

class ChatsRemoteDataSourceImpl implements ChatsRemoteDataSource {
  final FirebaseHelper firebaseHelper;

  ChatsRemoteDataSourceImpl({required this.firebaseHelper});
  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats() {
    return firebaseHelper.getChats();
  }
}
