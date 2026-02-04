

part of 'service.dart';


class ServiceAdapter extends TypeAdapter<Service> {
  @override
  final int typeId = 0;

  @override
  Service read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Service(
      code: fields[0] as String,
      serviceTypeName: fields[1] as String,
      serviceRecDetail: fields[2] as String,
      fee: fields[3] as String,
      time: fields[4] as String,
      serviceProvider: fields[5] as String,
      complainListen: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Service obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.code)
      ..writeByte(1)
      ..write(obj.serviceTypeName)
      ..writeByte(2)
      ..write(obj.serviceRecDetail)
      ..writeByte(3)
      ..write(obj.fee)
      ..writeByte(4)
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.serviceProvider)
      ..writeByte(6)
      ..write(obj.complainListen);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
