import 'package:dio/dio.dart';
import 'package:final_nuntius/core/apis/agora/agora_end_points.dart';
import 'package:retrofit/retrofit.dart';

part 'agora_api.g.dart';

@RestApi(baseUrl: AgoraEndPoints.baseUrl)
abstract class AgoraApi {
  factory AgoraApi(Dio dio, {String baseUrl}) = _AgoraApi;

  @GET("test/publisher/uid/1")
  Future<String> generateToken();
}
