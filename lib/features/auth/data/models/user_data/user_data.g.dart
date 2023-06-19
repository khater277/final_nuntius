// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 0;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      token: fields[0] as String?,
      name: fields[1] as String?,
      uId: fields[2] as String?,
      phone: fields[3] as String?,
      image: fields[4] as String?,
      inCall: fields[5] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.token)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.uId)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.inCall);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserData _$$_UserDataFromJson(Map<String, dynamic> json) => _$_UserData(
      token: json['token'] as String?,
      name: json['name'] as String?,
      uId: json['uId'] as String?,
      phone: json['phone'] as String?,
      image: json['image'] as String?,
      inCall: json['inCall'] as bool?,
    );

Map<String, dynamic> _$$_UserDataToJson(_$_UserData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'name': instance.name,
      'uId': instance.uId,
      'phone': instance.phone,
      'image': instance.image,
      'inCall': instance.inCall,
    };
