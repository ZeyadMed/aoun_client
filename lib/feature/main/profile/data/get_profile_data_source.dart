import 'package:aoun_client/core/helpers/helpers.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/core/http/http.dart';
import 'package:aoun_client/feature/main/profile/model/get_profile_model.dart';

abstract interface class GetProfileDataSource {
  Future<Either<Failure, GetProfileModel>> getProfileData();
}

class GetProfileDataSourceImpl implements GetProfileDataSource {
  final GenericDataSource genericDataSource;

  GetProfileDataSourceImpl(this.genericDataSource);

  @override
  Future<Either<Failure, GetProfileModel>> getProfileData() async {
    return genericDataSource.fetchResult(
      endpoint: Endpoints.getProfile,
      fromJson: (json) => GetProfileModel.fromJson(json),
    );
  }
}
