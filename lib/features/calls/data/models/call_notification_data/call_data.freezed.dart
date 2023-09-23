// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CallData _$CallDataFromJson(Map<String, dynamic> json) {
  return _CallData.fromJson(json);
}

/// @nodoc
mixin _$CallData {
  String? get type => throw _privateConstructorUsedError;
  String? get callId => throw _privateConstructorUsedError;
  String? get token => throw _privateConstructorUsedError;
  String? get channelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'senderID')
  String? get senderId => throw _privateConstructorUsedError;
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'click_action')
  String? get clickAction => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CallDataCopyWith<CallData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CallDataCopyWith<$Res> {
  factory $CallDataCopyWith(CallData value, $Res Function(CallData) then) =
      _$CallDataCopyWithImpl<$Res, CallData>;
  @useResult
  $Res call(
      {String? type,
      String? callId,
      String? token,
      String? channelName,
      @JsonKey(name: 'senderID') String? senderId,
      String? phoneNumber,
      @JsonKey(name: 'click_action') String? clickAction});
}

/// @nodoc
class _$CallDataCopyWithImpl<$Res, $Val extends CallData>
    implements $CallDataCopyWith<$Res> {
  _$CallDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? callId = freezed,
    Object? token = freezed,
    Object? channelName = freezed,
    Object? senderId = freezed,
    Object? phoneNumber = freezed,
    Object? clickAction = freezed,
  }) {
    return _then(_value.copyWith(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      callId: freezed == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      channelName: freezed == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      clickAction: freezed == clickAction
          ? _value.clickAction
          : clickAction // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CallDataCopyWith<$Res> implements $CallDataCopyWith<$Res> {
  factory _$$_CallDataCopyWith(
          _$_CallData value, $Res Function(_$_CallData) then) =
      __$$_CallDataCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? type,
      String? callId,
      String? token,
      String? channelName,
      @JsonKey(name: 'senderID') String? senderId,
      String? phoneNumber,
      @JsonKey(name: 'click_action') String? clickAction});
}

/// @nodoc
class __$$_CallDataCopyWithImpl<$Res>
    extends _$CallDataCopyWithImpl<$Res, _$_CallData>
    implements _$$_CallDataCopyWith<$Res> {
  __$$_CallDataCopyWithImpl(
      _$_CallData _value, $Res Function(_$_CallData) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = freezed,
    Object? callId = freezed,
    Object? token = freezed,
    Object? channelName = freezed,
    Object? senderId = freezed,
    Object? phoneNumber = freezed,
    Object? clickAction = freezed,
  }) {
    return _then(_$_CallData(
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      callId: freezed == callId
          ? _value.callId
          : callId // ignore: cast_nullable_to_non_nullable
              as String?,
      token: freezed == token
          ? _value.token
          : token // ignore: cast_nullable_to_non_nullable
              as String?,
      channelName: freezed == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String?,
      senderId: freezed == senderId
          ? _value.senderId
          : senderId // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      clickAction: freezed == clickAction
          ? _value.clickAction
          : clickAction // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CallData implements _CallData {
  _$_CallData(
      {this.type,
      this.callId,
      this.token,
      this.channelName,
      @JsonKey(name: 'senderID') this.senderId,
      this.phoneNumber,
      @JsonKey(name: 'click_action') this.clickAction});

  factory _$_CallData.fromJson(Map<String, dynamic> json) =>
      _$$_CallDataFromJson(json);

  @override
  final String? type;
  @override
  final String? callId;
  @override
  final String? token;
  @override
  final String? channelName;
  @override
  @JsonKey(name: 'senderID')
  final String? senderId;
  @override
  final String? phoneNumber;
  @override
  @JsonKey(name: 'click_action')
  final String? clickAction;

  @override
  String toString() {
    return 'CallData(type: $type, callId: $callId, token: $token, channelName: $channelName, senderId: $senderId, phoneNumber: $phoneNumber, clickAction: $clickAction)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CallData &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.callId, callId) || other.callId == callId) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.senderId, senderId) ||
                other.senderId == senderId) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.clickAction, clickAction) ||
                other.clickAction == clickAction));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, callId, token, channelName,
      senderId, phoneNumber, clickAction);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CallDataCopyWith<_$_CallData> get copyWith =>
      __$$_CallDataCopyWithImpl<_$_CallData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CallDataToJson(
      this,
    );
  }
}

abstract class _CallData implements CallData {
  factory _CallData(
      {final String? type,
      final String? callId,
      final String? token,
      final String? channelName,
      @JsonKey(name: 'senderID') final String? senderId,
      final String? phoneNumber,
      @JsonKey(name: 'click_action') final String? clickAction}) = _$_CallData;

  factory _CallData.fromJson(Map<String, dynamic> json) = _$_CallData.fromJson;

  @override
  String? get type;
  @override
  String? get callId;
  @override
  String? get token;
  @override
  String? get channelName;
  @override
  @JsonKey(name: 'senderID')
  String? get senderId;
  @override
  String? get phoneNumber;
  @override
  @JsonKey(name: 'click_action')
  String? get clickAction;
  @override
  @JsonKey(ignore: true)
  _$$_CallDataCopyWith<_$_CallData> get copyWith =>
      throw _privateConstructorUsedError;
}
