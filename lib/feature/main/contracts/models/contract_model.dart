import 'package:equatable/equatable.dart';

// ─── Models ───────────────────────────────────────────────────
enum ContractStatus { active, late, ended }

class InstallmentRow extends Equatable {
  final int number;
  final String date;
  final String method;
  final double due;
  final double paid;
  final double remain;
  final String status; // done|partial|late|upcoming

  const InstallmentRow({
    required this.number, required this.date, required this.method,
    required this.due, required this.paid, required this.remain, required this.status,
  });

  factory InstallmentRow.fromJson(Map<String, dynamic> json) => InstallmentRow(
    number: json['number'] ?? 0, date: json['date'] ?? '',
    method: json['method'] ?? '—', due: (json['due'] ?? 0).toDouble(),
    paid: (json['paid'] ?? 0).toDouble(), remain: (json['remain'] ?? 0).toDouble(),
    status: json['status'] ?? 'upcoming',
  );

  @override
  List<Object?> get props => [number, date, status];
}

class ContractModel extends Equatable {
  final int id;
  final String contractNo;
  final String productName;
  final String startDate;
  final double totalAmount;
  final double paidAmount;
  final double remainAmount;
  final double installmentAmount;
  final int totalInstallments;
  final int paidInstallments;
  final String installmentType;
  final ContractStatus status;
  final double salePrice;
  final double downPayment;
  final double profitRate;
  final String dueDay;
  final List<InstallmentRow> schedule;

  const ContractModel({
    required this.id, required this.contractNo, required this.productName,
    required this.startDate, required this.totalAmount, required this.paidAmount,
    required this.remainAmount, required this.installmentAmount,
    required this.totalInstallments, required this.paidInstallments,
    required this.installmentType, required this.status,
    this.salePrice = 0, this.downPayment = 0, this.profitRate = 0,
    this.dueDay = '1', this.schedule = const [],
  });

  double get progressPct => totalInstallments == 0 ? 0 : paidInstallments / totalInstallments;
  bool get isLate => status == ContractStatus.late;

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    id: json['id'] ?? 0, contractNo: json['contract_no'] ?? '',
    productName: json['product_name'] ?? '', startDate: json['start_date'] ?? '',
    totalAmount: (json['total_amount'] ?? 0).toDouble(),
    paidAmount: (json['paid_amount'] ?? 0).toDouble(),
    remainAmount: (json['remain_amount'] ?? 0).toDouble(),
    installmentAmount: (json['installment_amount'] ?? 0).toDouble(),
    totalInstallments: json['total_installments'] ?? 0,
    paidInstallments: json['paid_installments'] ?? 0,
    installmentType: json['installment_type'] ?? 'monthly',
    status: ContractStatus.values.firstWhere(
      (s) => s.name == (json['status'] ?? 'active'),
      orElse: () => ContractStatus.active,
    ),
    salePrice: (json['sale_price'] ?? 0).toDouble(),
    downPayment: (json['down_payment'] ?? 0).toDouble(),
    profitRate: (json['profit_rate'] ?? 0).toDouble(),
    dueDay: json['due_day'] ?? '1',
    schedule: (json['schedule'] as List? ?? []).map((r) => InstallmentRow.fromJson(r)).toList(),
  );

  @override
  List<Object?> get props => [id, contractNo, status, paidInstallments];
}
