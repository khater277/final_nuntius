part of 'calls_cubit.dart';

@freezed
class CallsState with _$CallsState {
  const factory CallsState.initial() = _Initial;
  const factory CallsState.generateTokenLoading() = _GenerateTokenLoading;
  const factory CallsState.generateTokenSuccess(String token) =
      _GenerateTokenSuccess;
  const factory CallsState.generateTokenError(String errorMsg) =
      _GenerateTokenError;
  const factory CallsState.setupVoiceSDKEngine() = _SetupVoiceSDKEngine;
  const factory CallsState.onJoinChannelSuccess() = _OnJoinChannelSuccess;
  const factory CallsState.onUserJoined() = _OnUserJoined;
  const factory CallsState.onUserOffline() = _OnUserOffline;
  const factory CallsState.joinVoiceCallLoading() = _JoinVoiceCallLoading;
  const factory CallsState.joinVoiceCall() = _JoinVoiceCall;
  const factory CallsState.joinVoiceCallError(String errorMsg) =
      _JoinVoiceCallError;
  const factory CallsState.leaveVoiceCallLoading() = _LeaveVoiceCallLoading;
  const factory CallsState.leaveVoiceCall() = _LeaveVoiceCall;
}
