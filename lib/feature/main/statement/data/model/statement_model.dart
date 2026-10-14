import 'package:equatable/equatable.dart';

enum StatementInstallmentStatus { paid, partial, late, upcoming }

class StatementModel extends Equatable {
  final int contractId;
  final int productId;
  final String productName;
  final String contractNumber;
  final DateTime? purchaseDate;
  final num totalContractAmount;
  final num totalPaid;
  final num remainingAmount;
  final StatementProgress progress;
  final StatementNextInstallment? nextInstallment;
  final List<StatementInstallment> installments;

  const StatementModel({
    required this.contractId,
    required this.productId,
    required this.productName,
    required this.contractNumber,
    required this.purchaseDate,
    required this.totalContractAmount,
    required this.totalPaid,
    required this.remainingAmount,
    required this.progress,
    required this.nextInstallment,
    required this.installments,
  });

  bool get isLate =>
      installments.any((i) => i.statusEnum == StatementInstallmentStatus.late);

  factory StatementModel.fromJson(Map<String, dynamic> json) => StatementModel(
        contractId: (json['contractId'] as num?)?.toInt() ?? 0,
        productId: (json['productId'] as num?)?.toInt() ?? 0,
        productName: json['productName'] ?? '',
        contractNumber: json['contractNumber'] ?? '',
        purchaseDate: DateTime.tryParse(json['purchaseDate'] ?? ''),
        totalContractAmount: (json['totalContractAmount'] as num?) ?? 0,
        totalPaid: (json['totalPaid'] as num?) ?? 0,
        remainingAmount: (json['remainingAmount'] as num?) ?? 0,
        progress: StatementProgress.fromJson(
          (json['progress'] as Map<String, dynamic>?) ?? const {},
        ),
        nextInstallment: json['nextInstallment'] == null
            ? null
            : StatementNextInstallment.fromJson(
                json['nextInstallment'] as Map<String, dynamic>,
              ),
        installments: ((json['installments'] as List?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(StatementInstallment.fromJson)
            .toList(),
      );

  @override
  List<Object?> get props => [
        contractId,
        productId,
        productName,
        contractNumber,
        totalContractAmount,
        totalPaid,
        remainingAmount,
        progress,
        nextInstallment,
        installments,
      ];
}

class StatementProgress extends Equatable {
  final int paidInstallmentsCount;
  final int totalInstallmentsCount;
  final num percent;

  const StatementProgress({
    required this.paidInstallmentsCount,
    required this.totalInstallmentsCount,
    required this.percent,
  });

  double get pct => totalInstallmentsCount == 0
      ? 0
      : (paidInstallmentsCount / totalInstallmentsCount).clamp(0, 1).toDouble();

  factory StatementProgress.fromJson(Map<String, dynamic> json) =>
      StatementProgress(
        paidInstallmentsCount:
            (json['paidInstallmentsCount'] as num?)?.toInt() ?? 0,
        totalInstallmentsCount:
            (json['totalInstallmentsCount'] as num?)?.toInt() ?? 0,
        percent: (json['percent'] as num?) ?? 0,
      );

  @override
  List<Object?> get props =>
      [paidInstallmentsCount, totalInstallmentsCount, percent];
}

class StatementNextInstallment extends Equatable {
  final num amount;
  final DateTime? dueDate;

  const StatementNextInstallment({required this.amount, required this.dueDate});

  factory StatementNextInstallment.fromJson(Map<String, dynamic> json) =>
      StatementNextInstallment(
        amount: (json['amount'] as num?) ?? 0,
        dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
      );

  @override
  List<Object?> get props => [amount, dueDate];
}

class StatementInstallment extends Equatable {
  final int sequence;
  final DateTime? dueDate;
  final num amount;
  final num paidAmount;
  final num remaining;
  final String rawStatus;
  final DateTime? paidDate;

  const StatementInstallment({
    required this.sequence,
    required this.dueDate,
    required this.amount,
    required this.paidAmount,
    required this.remaining,
    required this.rawStatus,
    required this.paidDate,
  });

  StatementInstallmentStatus get statusEnum {
    switch (rawStatus.toLowerCase()) {
      case 'paid':
      case 'done':
        return StatementInstallmentStatus.paid;
      case 'partial':
        return StatementInstallmentStatus.partial;
      case 'late':
      case 'overdue':
        return StatementInstallmentStatus.late;
      default:
        return StatementInstallmentStatus.upcoming;
    }
  }

  factory StatementInstallment.fromJson(Map<String, dynamic> json) =>
      StatementInstallment(
        sequence: (json['sequence'] as num?)?.toInt() ?? 0,
        dueDate: DateTime.tryParse(json['dueDate'] ?? ''),
        amount: (json['amount'] as num?) ?? 0,
        paidAmount: (json['paidAmount'] as num?) ?? 0,
        remaining: (json['remaining'] as num?) ?? 0,
        rawStatus: json['status'] ?? '',
        paidDate: DateTime.tryParse(json['paidDate'] ?? ''),
      );

  @override
  List<Object?> get props =>
      [sequence, dueDate, amount, paidAmount, remaining, rawStatus, paidDate];
}
