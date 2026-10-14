import 'package:equatable/equatable.dart';
import 'package:aoun_client/feature/main/catalog/data/model/add_to_cart_model.dart';

class UpdateCartItemModel extends Equatable {
  final int quantity;
  final OrderPaymentMethod paymentMethod;
  final int installmentMonths;

  const UpdateCartItemModel({
    required this.quantity,
    required this.paymentMethod,
    required this.installmentMonths,
  });

  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'paymentMethod': paymentMethod == OrderPaymentMethod.cash
        ? 'Cash'
        : 'Installment',
    'installmentMonths': installmentMonths,
  };

  @override
  List<Object?> get props => [quantity, paymentMethod, installmentMonths];
}
