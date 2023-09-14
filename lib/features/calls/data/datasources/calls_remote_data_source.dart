import 'package:final_nuntius/core/apis/agora/agora_api.dart';
import 'package:final_nuntius/features/messages/data/models/agora_token/agora_token_model/agora_token_model.dart';

abstract class CallsRemoteDataSource {
  Future<AgoraTokenModel> generateToken(
      {required String channel, required String uid});
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final AgoraApi agoraApi;

  CallsRemoteDataSourceImpl({required this.agoraApi});
  @override
  Future<AgoraTokenModel> generateToken(
      {required String channel, required String uid}) {
    return agoraApi.generateToken(channel, uid);
  }
}
