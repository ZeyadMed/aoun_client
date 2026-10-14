import 'package:equatable/equatable.dart';

class VerifyOtpEvent extends Equatable {
  final String phoneNumber;
  final String otpCode;

  const VerifyOtpEvent({
    required this.phoneNumber,
    required this.otpCode,
  });

  @override
  List<Object?> get props => [phoneNumber, otpCode];
}
