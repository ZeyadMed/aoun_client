import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';

abstract interface class ForgetPasswordDataSource {
  Future<Either<Failure, String>> forgetPassword({required String phoneNumber});
}

class ForgetPasswordDataSourceImpl implements ForgetPasswordDataSource {
  final GenericDataSource genericDataSource;
  ForgetPasswordDataSourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, String>> forgetPassword({
    required String phoneNumber,
  }) async {
    return genericDataSource.postData<String>(
      endpoint: Endpoints.forgetPassword,
      data: {"phoneNumber": phoneNumber},
      headers: {"Authorization": null},
      skipAuthRefresh: true,
    );
  }
}
