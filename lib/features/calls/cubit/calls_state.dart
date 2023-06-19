part of 'calls_cubit.dart';

@freezed
class CallsState with _$CallsState {
  const factory CallsState.initial() = _Initial;
  const factory CallsState.generateTokenLoading() = _GenerateTokenLoading;
  const factory CallsState.generateTokenSuccess(String token) =
      _GenerateTokenSuccess;
  const factory CallsState.generateTokenError(String errorMsg) =
      _GenerateTokenError;
}
