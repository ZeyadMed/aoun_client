import 'package:equatable/equatable.dart';

class ContractProductModel extends Equatable {
  final int id;
  final String name;

  const ContractProductModel({required this.id, required this.name});

  factory ContractProductModel.fromJson(Map<String, dynamic> json) =>
      ContractProductModel(
        id: (json['id'] as num?)?.toInt() ?? 0,
        name: json['name'] ?? '',
      );

  @override
  List<Object?> get props => [id, name];
}
