import 'package:equatable/equatable.dart';

class CreateOrderModel extends Equatable {
  final String notes;
  final String deliveryAddress;
  final DateTime preferredDeliveryDate;

  const CreateOrderModel({
    required this.notes,
    required this.deliveryAddress,
    required this.preferredDeliveryDate,
  });

  Map<String, dynamic> toJson() {
    final y = preferredDeliveryDate.year.toString().padLeft(4, '0');
    final m = preferredDeliveryDate.month.toString().padLeft(2, '0');
    final d = preferredDeliveryDate.day.toString().padLeft(2, '0');
    return {
      'notes': notes,
      'deliveryAddress': deliveryAddress,
      'preferredDeliveryDate': '$y-$m-$d',
    };
  }

  @override
  List<Object?> get props => [notes, deliveryAddress, preferredDeliveryDate];
}
