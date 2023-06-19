import 'package:final_nuntius/core/apis/agora/agora_api.dart';

abstract class CallsRemoteDataSource {
  Future<String> generateToken();
}

class CallsRemoteDataSourceImpl implements CallsRemoteDataSource {
  final AgoraApi agoraApi;

  CallsRemoteDataSourceImpl({required this.agoraApi});
  @override
  Future<String> generateToken() {
    return agoraApi.generateToken();
  }
}
