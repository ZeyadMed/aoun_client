import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/profile/data/get_profile_data_source.dart';
import 'package:aoun_client/feature/main/profile/model/get_profile_model.dart';

class GetProfileCubit extends Cubit<BaseState<GetProfileModel>> {
  final GetProfileDataSource getProfileDataSource;
  GetProfileCubit(this.getProfileDataSource) : super(BaseState());
  Future<void> getProfile() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getProfileDataSource.getProfileData();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: Status.failure, failure: failure)),
      (profile) => emit(state.copyWith(status: Status.success, data: profile)),
    );
  }
}
