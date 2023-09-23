// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_notification_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CallNotificationData _$$_CallNotificationDataFromJson(
        Map<String, dynamic> json) =>
    _$_CallNotificationData(
      to: json['to'] as String?,
      priority: json['priority'] as String?,
      callData: json['data'] == null
          ? null
          : CallData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CallNotificationDataToJson(
        _$_CallNotificationData instance) =>
    <String, dynamic>{
      'to': instance.to,
      'priority': instance.priority,
      'data': instance.callData,
    };
