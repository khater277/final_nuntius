// ignore_for_file: unused_field, prefer_final_fields

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:final_nuntius/core/apis/agora/agora_end_points.dart';
import 'package:final_nuntius/features/calls/data/repositories/calls_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';

part 'calls_cubit.freezed.dart';
part 'calls_state.dart';

class CallsCubit extends Cubit<CallsState> {
  final CallsRepository callsRepository;
  CallsCubit({required this.callsRepository})
      : super(const CallsState.initial());

  static CallsCubit get(context) => BlocProvider.of(context);

  int uid = 0;

  int? remoteUid;
  bool isJoined = false;
  RtcEngine? agoraEngine;

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  showMessage(String message) {
    scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  void setupVoiceSDKEngine(
      {required String token, required String channelName}) async {
    emit(const CallsState.joinVoiceCallLoading());
    await [Permission.microphone].request();

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine!
        .initialize(const RtcEngineContext(appId: AgoraEndPoints.appId));
    agoraEngine!.enableAudio();

    agoraEngine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          showMessage(
              "Local user uid:${connection.localUid} joined the channel");
          isJoined = true;
          emit(const CallsState.onJoinChannelSuccess());
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          showMessage("Remote user uid:$remoteUid joined the channel");
          this.remoteUid = remoteUid;
          emit(const CallsState.onUserJoined());
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          showMessage("Remote user uid:$remoteUid left the channel");
          this.remoteUid = null;
          emit(const CallsState.onUserOffline());
        },
      ),
    );

    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine!.joinChannel(
      token: token,
      channelId: channelName,
      options: options,
      uid: uid,
    );
    // emit(const CallsState.joinVoiceCall());
  }

  void leaveVoiceCall() async {
    emit(const CallsState.leaveVoiceCallLoading());
    isJoined = false;
    remoteUid = null;
    Future.delayed(const Duration(seconds: 0)).then((value) async {
      await agoraEngine!.leaveChannel();
      emit(const CallsState.leaveVoiceCall());
    });
  }
}
