import 'package:equatable/equatable.dart';

class CustomerModel extends Equatable {
  final int id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? whatsappNumber;
  final String? nationalId;
  final String rating;
  final String token;
  final double totalDebt;
  final double complianceRate;
  final int activeContracts;
  final int dealingYears;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.whatsappNumber,
    this.nationalId,
    required this.rating,
    required this.token,
    this.totalDebt = 0,
    this.complianceRate = 0,
    this.activeContracts = 0,
    this.dealingYears = 0,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'],
    address: json['address'],
    whatsappNumber: json['whatsapp_number'],
    nationalId: json['national_id'],
    rating: json['rating'] ?? 'B',
    token: json['token'] ?? '',
    totalDebt: (json['total_debt'] ?? 0).toDouble(),
    complianceRate: (json['compliance_rate'] ?? 0).toDouble(),
    activeContracts: json['active_contracts'] ?? 0,
    dealingYears: json['dealing_years'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'phone': phone,
    'email': email, 'address': address,
    'whatsapp_number': whatsappNumber, 'national_id': nationalId,
    'rating': rating, 'token': token,
    'total_debt': totalDebt, 'compliance_rate': complianceRate,
    'active_contracts': activeContracts, 'dealing_years': dealingYears,
  };

  CustomerModel copyWith({
    String? name, String? phone, String? email,
    String? address, String? whatsappNumber,
  }) => CustomerModel(
    id: id, name: name ?? this.name, phone: phone ?? this.phone,
    email: email ?? this.email, address: address ?? this.address,
    whatsappNumber: whatsappNumber ?? this.whatsappNumber,
    nationalId: nationalId, rating: rating, token: token,
    totalDebt: totalDebt, complianceRate: complianceRate,
    activeContracts: activeContracts, dealingYears: dealingYears,
  );

  @override
  List<Object?> get props => [id, name, phone, email, rating, token];
}
