import 'package:equatable/equatable.dart';

enum InstallmentStatus { upcoming, paid, partial, late }

class ContractInstallmentModel extends Equatable {
  final int id;
  final int sequence;
  final DateTime? dueDate;
  final num amount;
  final num paidAmount;
  final num remaining;
  final String rawStatus;
  final DateTime? paidDate;

  const ContractInstallmentModel({
    required this.id,
    required this.sequence,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.remaining,
    required this.rawStatus,
    required this.paidDate,
  });

  InstallmentStatus get status {
    switch (rawStatus.toLowerCase()) {
      case 'paid':
      case 'done':
        return InstallmentStatus.paid;
      case 'partial':
        return InstallmentStatus.partial;
      case 'late':
      case 'overdue':
        return InstallmentStatus.late;
      default:
        return InstallmentStatus.upcoming;
    }
  }

  factory ContractInstallmentModel.fromJson(Map<String, dynamic> json) =>
      ContractInstallmentModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
        amount: (json['amount'] as num?) ?? 0,
        paidAmount: (json['paidAmount'] as num?) ?? 0,
        remaining: (json['remaining'] as num?) ?? 0,
        rawStatus: json['status'] ?? 'Upcoming',
        paidDate: json['paidDate'] == null
            ? null
            : DateTime.tryParse(json['paidDate']),
      );

  @override
  List<Object?> get props => [id, sequence, rawStatus, paidAmount, remaining];
}
