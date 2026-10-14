import 'package:equatable/equatable.dart';

class OverdueInstallmentModel extends Equatable {
  final int installmentId;
  final int contractId;
  final int productId;
  final String productName;
  final int sequence;
  final DateTime? dueDate;
  final num amount;
  final num paidAmount;
  final num remaining;
  final int daysOverdue;

  const OverdueInstallmentModel({
    required this.installmentId,
    required this.contractId,
    required this.productId,
    required this.productName,
    required this.sequence,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.remaining,
    required this.daysOverdue,
  });

  factory OverdueInstallmentModel.fromJson(Map<String, dynamic> json) =>
      OverdueInstallmentModel(
        installmentId: (json['installmentId'] as num?)?.toInt() ?? 0,
        contractId: (json['contractId'] as num?)?.toInt() ?? 0,
        productId: (json['productId'] as num?)?.toInt() ?? 0,
        productName: json['productName']?.toString() ?? '',
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        dueDate: DateTime.tryParse(json['dueDate']?.toString() ?? ''),
        amount: (json['amount'] as num?) ?? 0,
        paidAmount: (json['paidAmount'] as num?) ?? 0,
        remaining: (json['remaining'] as num?) ?? 0,
        daysOverdue: (json['daysOverdue'] as num?)?.toInt() ?? 0,
      );

  @override
  List<Object?> get props => [
        installmentId,
        contractId,
        sequence,
        remaining,
        daysOverdue,
      ];
}
