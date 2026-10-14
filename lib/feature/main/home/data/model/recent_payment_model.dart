import 'package:equatable/equatable.dart';

class RecentPaymentModel extends Equatable {
  final int installmentId;
  final int contractId;
  final String productName;
  final int sequence;
  final bool isFullyPaid;
  final num amount;
  final DateTime? paidDate;

  const RecentPaymentModel({
    required this.installmentId,
    required this.contractId,
    required this.productName,
    required this.sequence,
    required this.isFullyPaid,
    required this.amount,
    required this.paidDate,
  });

  factory RecentPaymentModel.fromJson(Map<String, dynamic> json) =>
      RecentPaymentModel(
        installmentId: (json['installmentId'] as num?)?.toInt() ?? 0,
        contractId: (json['contractId'] as num?)?.toInt() ?? 0,
        productName: json['productName']?.toString() ?? '',
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        isFullyPaid: json['isFullyPaid'] == true,
        amount: (json['amount'] as num?) ?? 0,
        paidDate: DateTime.tryParse(json['paidDate']?.toString() ?? ''),
      );

  @override
  List<Object?> get props => [
        installmentId,
        contractId,
        sequence,
        isFullyPaid,
        amount,
        paidDate,
      ];
}
