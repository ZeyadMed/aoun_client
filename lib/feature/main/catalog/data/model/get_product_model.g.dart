// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GetProductModelAdapter extends TypeAdapter<GetProductModel> {
  @override
  final int typeId = 3;

  @override
  GetProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GetProductModel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      imageUrl: fields[3] as String?,
      cashPrice: fields[4] as num,
      profitRatePercent: fields[5] as num,
      installmentPlans: (fields[6] as List).cast<InstallmentPlanModel>(),
      availableQuantity: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, GetProductModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.cashPrice)
      ..writeByte(5)
      ..write(obj.profitRatePercent)
      ..writeByte(6)
      ..write(obj.installmentPlans)
      ..writeByte(7)
      ..write(obj.availableQuantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GetProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InstallmentPlanModelAdapter extends TypeAdapter<InstallmentPlanModel> {
  @override
  final int typeId = 4;

  @override
  InstallmentPlanModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InstallmentPlanModel(
      months: fields[0] as int,
      totalPrice: fields[1] as num,
      downPayment: fields[2] as num,
      downPaymentPercent: fields[3] as num,
      monthlyInstallment: fields[4] as num,
    );
  }

  @override
  void write(BinaryWriter writer, InstallmentPlanModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.months)
      ..writeByte(1)
      ..write(obj.totalPrice)
      ..writeByte(2)
      ..write(obj.downPayment)
      ..writeByte(3)
      ..write(obj.downPaymentPercent)
      ..writeByte(4)
      ..write(obj.monthlyInstallment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InstallmentPlanModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
