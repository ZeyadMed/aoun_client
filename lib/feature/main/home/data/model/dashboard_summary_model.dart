import 'package:equatable/equatable.dart';

class DashboardSummaryModel extends Equatable {
  final String clientName;
  final String today;
  final num totalDebt;
  final NextInstallmentModel nextInstallment;
  final int totalInstallments;
  final int paidInstallments;
  final int percentPaid;

  const DashboardSummaryModel({
    required this.clientName,
    required this.today,
    required this.totalDebt,
    required this.nextInstallment,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.percentPaid,
  });

  double get progressPct =>
      totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) {
    return DashboardSummaryModel(
      clientName: json['clientName'] ?? '',
      today: json['today'] ?? '',
      totalDebt: (json['totalDebt'] ?? 0).toDouble(),
      nextInstallment: NextInstallmentModel.fromJson(
        json['nextInstallment'] ?? {},
      ),
      totalInstallments: (json['totalInstallments'] as num?)?.toInt() ?? 0,
      paidInstallments: (json['paidInstallments'] as num?)?.toInt() ?? 0,
      percentPaid: (json['percentPaid'] as num?)?.round() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    clientName,
    today,
    totalDebt,
    nextInstallment,
    totalInstallments,
    paidInstallments,
    percentPaid,
  ];
}

class NextInstallmentModel extends Equatable {
  final num amount;
  final String dueDate;
  final int daysUntilDue;

  const NextInstallmentModel({
    required this.amount,
    required this.dueDate,
    required this.daysUntilDue,
  });

  factory NextInstallmentModel.fromJson(Map<String, dynamic> json) {
    return NextInstallmentModel(
      amount: (json['amount'] ?? 0).toDouble(),
      dueDate: json['duedate'] ?? json['dueDate'] ?? '',
      daysUntilDue: (json['daysUntilDue'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [amount, dueDate, daysUntilDue];
}
