import 'package:equatable/equatable.dart';

enum OrderPaymentMethod { cash, installment }

class AddToCartModel extends Equatable {
  final int productId;
  final int quantity;
  final OrderPaymentMethod paymentMethod;
  final int installmentMonths; // 0 for cash, 6 or 12 for installment

  const AddToCartModel({
    required this.productId,
    required this.quantity,
    required this.paymentMethod,
    required this.installmentMonths,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'quantity': quantity,
    'paymentMethod': paymentMethod == OrderPaymentMethod.cash
        ? 'Cash'
        : 'Installment',
    'installmentMonths': installmentMonths,
  };

  @override
  List<Object?> get props => [
    productId,
    quantity,
    paymentMethod,
    installmentMonths,
  ];
}
