import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  final int id;
  final List<CartItemModel> items;
  final int totalItems;
  final num totalAmount;
  final num totalDownPayment;
  final num totalMonthlyInstallment;

  const CartModel({
    required this.id,
    required this.items,
    required this.totalItems,
    required this.totalAmount,
    required this.totalDownPayment,
    required this.totalMonthlyInstallment,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return CartModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      items: rawItems is List
          ? rawItems
                .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?) ?? 0,
      totalDownPayment: (json['totalDownPayment'] as num?) ?? 0,
      totalMonthlyInstallment: (json['totalMonthlyInstallment'] as num?) ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    id,
    items,
    totalItems,
    totalAmount,
    totalDownPayment,
    totalMonthlyInstallment,
  ];
}

class CartItemModel extends Equatable {
  final int id;
  final int productId;
  final String productName;
  final String? imageUrl;
  final int quantity;
  final String paymentMethod;
  final int? installmentMonths;
  final num unitPrice;
  final num lineTotal;
  final num? downPayment;
  final num? monthlyInstallment;

  const CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.imageUrl,
    required this.quantity,
    required this.paymentMethod,
    required this.installmentMonths,
    required this.unitPrice,
    required this.lineTotal,
    required this.downPayment,
    required this.monthlyInstallment,
  });

  bool get isInstallment => paymentMethod == 'Installment';

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      productName: json['productName'] ?? '',
      imageUrl: json['imageUrl'],
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      paymentMethod: json['paymentMethod'] ?? 'Cash',
      installmentMonths: (json['installmentMonths'] as num?)?.toInt(),
      unitPrice: (json['unitPrice'] as num?) ?? 0,
      lineTotal: (json['lineTotal'] as num?) ?? 0,
      downPayment: json['downPayment'] as num?,
      monthlyInstallment: json['monthlyInstallment'] as num?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    imageUrl,
    quantity,
    paymentMethod,
    installmentMonths,
    unitPrice,
    lineTotal,
    downPayment,
    monthlyInstallment,
  ];
}
