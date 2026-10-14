import 'package:equatable/equatable.dart';

class GetProfileModel extends Equatable {
  final String fullName;
  final String phoneNumber;
  final String address;

  final String rating;
  final String ratingText;

  final int activeContractsCount;

  final num totalDebt;
  final num commitmentPercent;

  final String durationText;
  final int durationYears;
  final int durationMonths;

  final String joinDate;

  const GetProfileModel({
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.rating,
    required this.ratingText,
    required this.activeContractsCount,
    required this.totalDebt,
    required this.commitmentPercent,
    required this.durationText,
    required this.durationYears,
    required this.durationMonths,
    required this.joinDate,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) {
    return GetProfileModel(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      address: json['address'] ?? '',

      rating: json['rating'] ?? '',
      ratingText: json['ratingText'] ?? '',

      activeContractsCount: json['activeContractsCount'] ?? 0,

      totalDebt: json['totalDebt'] ?? 0,
      commitmentPercent: json['commitmentPercent'] ?? 0,

      durationText: json['durationText'] ?? '',

      durationYears: json['durationYears'] ?? 0,
      durationMonths: json['durationMonths'] ?? 0,

      joinDate: json['joinDate'] ?? '',
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phoneNumber,
        address,
        rating,
        ratingText,
        activeContractsCount,
        totalDebt,
        commitmentPercent,
        durationText,
        durationYears,
        durationMonths,
        joinDate,
      ];
}