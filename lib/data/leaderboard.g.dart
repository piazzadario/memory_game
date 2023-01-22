// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LeaderboardAdapter extends TypeAdapter<Leaderboard> {
  @override
  final int typeId = 2;

  @override
  Leaderboard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Leaderboard(
      records: (fields[0] as List).cast<Game>(),
    );
  }

  @override
  void write(BinaryWriter writer, Leaderboard obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.records);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LeaderboardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
