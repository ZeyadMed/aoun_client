// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_token.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTokenAdapter extends TypeAdapter<UserToken> {
  @override
  final int typeId = 0;

  @override
  UserToken read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserToken(
      accessToken: fields[0] as String,
      refreshToken: fields[1] as String,
      userType: fields[2] as String,
      userId: fields[3] as String,
      email: fields[4] as String,
      userName: fields[5] as String,
      expiresAtUtc: fields[6] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserToken obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.accessToken)
      ..writeByte(1)
      ..write(obj.refreshToken)
      ..writeByte(2)
      ..write(obj.userType)
      ..writeByte(3)
      ..write(obj.userId)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.userName)
      ..writeByte(6)
      ..write(obj.expiresAtUtc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTokenAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
