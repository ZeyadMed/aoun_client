import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';

abstract interface class VerifyOtpDataSource {
  Future<Either<Failure, String>> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  });
}

class VerifyOtpDataSourceImpl implements VerifyOtpDataSource {
  final GenericDataSource genericDataSource;
  VerifyOtpDataSourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, String>> verifyOtp({
    required String phoneNumber,
    required String otpCode,
  }) async {
    return genericDataSource.postData<String>(
      endpoint: Endpoints.verifyOtp,
      data: {"phoneNumber": phoneNumber, "otpCode": otpCode},
      headers: {"Authorization": null},
      skipAuthRefresh: true,
    );
  }
}
