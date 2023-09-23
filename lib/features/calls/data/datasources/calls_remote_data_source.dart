import 'package:final_nuntius/core/apis/agora/agora_api.dart';
import 'package:final_nuntius/core/apis/fcm/fcm_api.dart';
import 'package:final_nuntius/features/messages/data/models/agora_token/agora_token_model/agora_token_model.dart';

abstract class CallsRemoteDataSource {
  Future<AgoraTokenModel> generateToken(
      {required String channel, required String uid});

  Future<Map<String, dynamic>> pushNotification({
    required Map<String, dynamic> fcmBody,
  });
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final AgoraApi agoraApi;
  final FcmApi fcmApi;

  CallsRemoteDataSourceImpl({required this.agoraApi, required this.fcmApi});
  @override
  Future<AgoraTokenModel> generateToken(
      {required String channel, required String uid}) {
    return agoraApi.generateToken(channel, uid);
  }

  @override
  Future<Map<String, dynamic>> pushNotification(
      {required Map<String, dynamic> fcmBody}) {
    return fcmApi.pushNotification(fcmBody: fcmBody);
  }
}
