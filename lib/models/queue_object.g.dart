// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_object.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QueueObjectAdapter extends TypeAdapter<QueueObject> {
  @override
  final int typeId = 1;

  @override
  QueueObject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QueueObject()
      ..id = fields[0] == null ? '' : fields[0] as String
      ..path = fields[1] == null ? '' : fields[1] as String
      ..name = fields[2] == null ? '' : fields[2] as String
      ..type = fields[3] == null ? '' : fields[3] as String
      ..message = fields[4] == null ? '' : fields[4] as String
      ..size = fields[5] == null ? 0.0 : fields[5] as num
      ..status = fields[6] == null ? 0.0 : fields[6] as num;
  }

  @override
  void write(BinaryWriter writer, QueueObject obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.size)
      ..writeByte(6)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QueueObjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
