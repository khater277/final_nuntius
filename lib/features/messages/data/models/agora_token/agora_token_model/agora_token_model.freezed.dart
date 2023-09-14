// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agora_token_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

AgoraTokenModel _$AgoraTokenModelFromJson(Map<String, dynamic> json) {
  return _AgoraTokenModel.fromJson(json);
}

/// @nodoc
mixin _$AgoraTokenModel {
  String? get rtcToken => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AgoraTokenModelCopyWith<AgoraTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AgoraTokenModelCopyWith<$Res> {
  factory $AgoraTokenModelCopyWith(
          AgoraTokenModel value, $Res Function(AgoraTokenModel) then) =
      _$AgoraTokenModelCopyWithImpl<$Res, AgoraTokenModel>;
  @useResult
  $Res call({String? rtcToken});
}

/// @nodoc
class _$AgoraTokenModelCopyWithImpl<$Res, $Val extends AgoraTokenModel>
    implements $AgoraTokenModelCopyWith<$Res> {
  _$AgoraTokenModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rtcToken = freezed,
  }) {
    return _then(_value.copyWith(
      rtcToken: freezed == rtcToken
          ? _value.rtcToken
          : rtcToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_AgoraTokenModelCopyWith<$Res>
    implements $AgoraTokenModelCopyWith<$Res> {
  factory _$$_AgoraTokenModelCopyWith(
          _$_AgoraTokenModel value, $Res Function(_$_AgoraTokenModel) then) =
      __$$_AgoraTokenModelCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? rtcToken});
}

/// @nodoc
class __$$_AgoraTokenModelCopyWithImpl<$Res>
    extends _$AgoraTokenModelCopyWithImpl<$Res, _$_AgoraTokenModel>
    implements _$$_AgoraTokenModelCopyWith<$Res> {
  __$$_AgoraTokenModelCopyWithImpl(
      _$_AgoraTokenModel _value, $Res Function(_$_AgoraTokenModel) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? rtcToken = freezed,
  }) {
    return _then(_$_AgoraTokenModel(
      rtcToken: freezed == rtcToken
          ? _value.rtcToken
          : rtcToken // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_AgoraTokenModel implements _AgoraTokenModel {
  _$_AgoraTokenModel({this.rtcToken});

  factory _$_AgoraTokenModel.fromJson(Map<String, dynamic> json) =>
      _$$_AgoraTokenModelFromJson(json);

  @override
  final String? rtcToken;

  @override
  String toString() {
    return 'AgoraTokenModel(rtcToken: $rtcToken)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_AgoraTokenModel &&
            (identical(other.rtcToken, rtcToken) ||
                other.rtcToken == rtcToken));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, rtcToken);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_AgoraTokenModelCopyWith<_$_AgoraTokenModel> get copyWith =>
      __$$_AgoraTokenModelCopyWithImpl<_$_AgoraTokenModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_AgoraTokenModelToJson(
      this,
    );
  }
}

abstract class _AgoraTokenModel implements AgoraTokenModel {
  factory _AgoraTokenModel({final String? rtcToken}) = _$_AgoraTokenModel;

  factory _AgoraTokenModel.fromJson(Map<String, dynamic> json) =
      _$_AgoraTokenModel.fromJson;

  @override
  String? get rtcToken;
  @override
  @JsonKey(ignore: true)
  _$$_AgoraTokenModelCopyWith<_$_AgoraTokenModel> get copyWith =>
      throw _privateConstructorUsedError;
}
