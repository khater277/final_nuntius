// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CallInfo _$$_CallInfoFromJson(Map<String, dynamic> json) => _$_CallInfo(
      callModel: json['callModel'] == null
          ? null
          : CallModel.fromJson(json['callModel'] as Map<String, dynamic>),
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$_CallInfoToJson(_$_CallInfo instance) =>
    <String, dynamic>{
      'callModel': instance.callModel,
      'name': instance.name,
      'image': instance.image,
    };
