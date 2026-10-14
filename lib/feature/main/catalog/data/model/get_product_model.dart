import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'get_product_model.g.dart';

@HiveType(typeId: 3)
class GetProductModel extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final num cashPrice;
  @HiveField(5)
  final num profitRatePercent;
  @HiveField(6)
  final List<InstallmentPlanModel> installmentPlans;
  @HiveField(7)
  final int availableQuantity;

  const GetProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.cashPrice,
    required this.profitRatePercent,
    required this.installmentPlans,
    required this.availableQuantity,
  });

  factory GetProductModel.fromJson(Map<String, dynamic> json) {
    final plans = (json['installmentPlans'] as List?) ?? const [];
    return GetProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] as String?,
      cashPrice: (json['cashPrice'] as num?) ?? 0,
      profitRatePercent: (json['profitRatePercent'] as num?) ?? 0,
      installmentPlans: plans
          .whereType<Map<String, dynamic>>()
          .map(InstallmentPlanModel.fromJson)
          .toList(),
      availableQuantity: (json['availableQuantity'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'cashPrice': cashPrice,
        'profitRatePercent': profitRatePercent,
        'installmentPlans': installmentPlans.map((e) => e.toJson()).toList(),
        'availableQuantity': availableQuantity,
      };

  static List<GetProductModel> listFromResponse(dynamic response) {
    final raw = response is Map<String, dynamic>
        ? (response['data'] ?? response)
        : response;
    if (raw is! List) return const [];
    return raw
        .whereType<Map<String, dynamic>>()
        .map(GetProductModel.fromJson)
        .toList();
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        cashPrice,
        profitRatePercent,
        installmentPlans,
        availableQuantity,
      ];
}

@HiveType(typeId: 4)
class InstallmentPlanModel extends Equatable {
  @HiveField(0)
  final int months;
  @HiveField(1)
  final num totalPrice;
  @HiveField(2)
  final num downPayment;
  @HiveField(3)
  final num downPaymentPercent;
  @HiveField(4)
  final num monthlyInstallment;

  const InstallmentPlanModel({
    required this.months,
    required this.totalPrice,
    required this.downPayment,
    required this.downPaymentPercent,
    required this.monthlyInstallment,
  });

  factory InstallmentPlanModel.fromJson(Map<String, dynamic> json) {
    return InstallmentPlanModel(
      months: (json['months'] as num?)?.toInt() ?? 0,
      totalPrice: (json['totalPrice'] as num?) ?? 0,
      downPayment: (json['downPayment'] as num?) ?? 0,
      downPaymentPercent: (json['downPaymentPercent'] as num?) ?? 0,
      monthlyInstallment: (json['monthlyInstallment'] as num?) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'months': months,
        'totalPrice': totalPrice,
        'downPayment': downPayment,
        'downPaymentPercent': downPaymentPercent,
        'monthlyInstallment': monthlyInstallment,
      };

  @override
  List<Object?> get props => [
        months,
        totalPrice,
        downPayment,
        downPaymentPercent,
        monthlyInstallment,
      ];
}
