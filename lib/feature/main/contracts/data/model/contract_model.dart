import 'package:equatable/equatable.dart';

enum ContractStatus { active, late, ended }

class ContractModel extends Equatable {
  final int id;
  final int clientId;
  final int productId;
  final String productName;
  final int quantity;
  final num cashPrice;
  final num downPayment;
  final int installmentsCount;
  final num installmentAmount;
  final num totalContractAmount;
  final num totalPaid;
  final num remainingAmount;
  final String rawStatus;
  final DateTime? purchaseDate;

  const ContractModel({
    required this.id,
    required this.clientId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.cashPrice,
    required this.downPayment,
    required this.installmentsCount,
    required this.installmentAmount,
    required this.totalContractAmount,
    required this.totalPaid,
    required this.remainingAmount,
    required this.rawStatus,
    required this.purchaseDate,
  });

  ContractStatus get status {
    switch (rawStatus.toLowerCase()) {
      case 'active':
      case 'ontrack':
      case 'on_track':
      case 'on-track':
        return ContractStatus.active;
      case 'late':
      case 'overdue':
        return ContractStatus.late;
      case 'ended':
      case 'completed':
      case 'closed':
        return ContractStatus.ended;
      default:
        return ContractStatus.active;
    }
  }

  bool get isLate => status == ContractStatus.late;
  bool get isEnded => status == ContractStatus.ended;
  bool get isActive => status == ContractStatus.active;

  int get paidInstallments {
    if (installmentAmount <= 0) return 0;
    final paidWithoutDown = totalPaid - downPayment;
    if (paidWithoutDown <= 0) return 0;
    final count = (paidWithoutDown / installmentAmount).floor();
    if (count < 0) return 0;
    if (count > installmentsCount) return installmentsCount;
    return count;
  }

  double get progressPct =>
      installmentsCount == 0 ? 0 : paidInstallments / installmentsCount;

  String get contractNo => '#${id.toString().padLeft(4, '0')}';

  factory ContractModel.fromJson(Map<String, dynamic> json) => ContractModel(
    id: (json['id'] as num?)?.toInt() ?? 0,
    clientId: (json['clientId'] as num?)?.toInt() ?? 0,
    productId: (json['productId'] as num?)?.toInt() ?? 0,
    productName: json['productName'] ?? '',
    quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    cashPrice: (json['cashPrice'] as num?) ?? 0,
    downPayment: (json['downPayment'] as num?) ?? 0,
    installmentsCount: (json['installmentsCount'] as num?)?.toInt() ?? 0,
    installmentAmount: (json['installmentAmount'] as num?) ?? 0,
    totalContractAmount: (json['totalContractAmount'] as num?) ?? 0,
    totalPaid: (json['totalPaid'] as num?) ?? 0,
    remainingAmount: (json['remainingAmount'] as num?) ?? 0,
    rawStatus: json['status'] ?? 'Active',
    purchaseDate: DateTime.tryParse(json['purchaseDate'] ?? ''),
  );

  @override
  List<Object?> get props => [
    id,
    productName,
    rawStatus,
    totalPaid,
    remainingAmount,
  ];
}
