// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modell.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ActivityAdapter extends TypeAdapter<Activity> {
  @override
  final int typeId = 0;

  @override
  Activity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Activity(
      name: fields[0] as String,
      begin: fields[1] as DateTime,
      last: fields[2] as DateTime,
      icolor: fields[3] as int,
      micon: (fields[4] as Map)?.cast<dynamic, dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Activity obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.begin)
      ..writeByte(2)
      ..write(obj.last)
      ..writeByte(3)
      ..write(obj.icolor)
      ..writeByte(4)
      ..write(obj.micon);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ActivitySetupAdapter extends TypeAdapter<ActivitySetup> {
  @override
  final int typeId = 1;

  @override
  ActivitySetup read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActivitySetup(
      name: fields[0] as String,
      icolor: fields[1] as int,
      micon: (fields[2] as Map)?.cast<dynamic, dynamic>(),
      favorite: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ActivitySetup obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icolor)
      ..writeByte(2)
      ..write(obj.micon)
      ..writeByte(3)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ActivitySetupAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      name: fields[0] as String,
      icolor: fields[1] as int,
      micon: (fields[2] as Map)?.cast<dynamic, dynamic>(),
      favorite: fields[3] as bool,
      activityBox: fields[4] as String,
      activitySetupBox: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.icolor)
      ..writeByte(2)
      ..write(obj.micon)
      ..writeByte(3)
      ..write(obj.favorite)
      ..writeByte(4)
      ..write(obj.activityBox)
      ..writeByte(5)
      ..write(obj.activitySetupBox);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
