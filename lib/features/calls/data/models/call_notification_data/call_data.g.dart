// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CallData _$$_CallDataFromJson(Map<String, dynamic> json) => _$_CallData(
      type: json['type'] as String?,
      callId: json['callId'] as String?,
      token: json['token'] as String?,
      channelName: json['channelName'] as String?,
      senderId: json['senderID'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      clickAction: json['click_action'] as String?,
    );

Map<String, dynamic> _$$_CallDataToJson(_$_CallData instance) =>
    <String, dynamic>{
      'type': instance.type,
      'callId': instance.callId,
      'token': instance.token,
      'channelName': instance.channelName,
      'senderID': instance.senderId,
      'phoneNumber': instance.phoneNumber,
      'click_action': instance.clickAction,
    };
