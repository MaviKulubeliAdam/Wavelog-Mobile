// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qso_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QsoModelAdapter extends TypeAdapter<QsoModel> {
  @override
  final int typeId = 0;

  @override
  QsoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QsoModel(
      localId: fields[0] as String?,
      callsign: fields[1] as String,
      dateTimeOn: fields[2] as DateTime,
      band: fields[3] as String,
      freqMhz: fields[4] as double?,
      mode: fields[5] as String,
      submode: fields[6] as String?,
      rstSent: fields[7] as String,
      rstRcvd: fields[8] as String,
      name: fields[9] as String?,
      qth: fields[10] as String?,
      gridSquare: fields[11] as String?,
      comment: fields[12] as String?,
      notes: fields[13] as String?,
      dxcc: fields[14] as String?,
      country: fields[15] as String?,
      continent: fields[16] as String?,
      stationProfileId: fields[17] as int,
      synced: fields[18] as bool,
      syncedAt: fields[19] as DateTime?,
      rawAdif: (fields[20] as Map?)
          ?.map((k, v) => MapEntry(k.toString(), v.toString())),
    );
  }

  @override
  void write(BinaryWriter writer, QsoModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.localId)
      ..writeByte(1)
      ..write(obj.callsign)
      ..writeByte(2)
      ..write(obj.dateTimeOn)
      ..writeByte(3)
      ..write(obj.band)
      ..writeByte(4)
      ..write(obj.freqMhz)
      ..writeByte(5)
      ..write(obj.mode)
      ..writeByte(6)
      ..write(obj.submode)
      ..writeByte(7)
      ..write(obj.rstSent)
      ..writeByte(8)
      ..write(obj.rstRcvd)
      ..writeByte(9)
      ..write(obj.name)
      ..writeByte(10)
      ..write(obj.qth)
      ..writeByte(11)
      ..write(obj.gridSquare)
      ..writeByte(12)
      ..write(obj.comment)
      ..writeByte(13)
      ..write(obj.notes)
      ..writeByte(14)
      ..write(obj.dxcc)
      ..writeByte(15)
      ..write(obj.country)
      ..writeByte(16)
      ..write(obj.continent)
      ..writeByte(17)
      ..write(obj.stationProfileId)
      ..writeByte(18)
      ..write(obj.synced)
      ..writeByte(19)
      ..write(obj.syncedAt)
      ..writeByte(20)
      ..write(obj.rawAdif);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QsoModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
