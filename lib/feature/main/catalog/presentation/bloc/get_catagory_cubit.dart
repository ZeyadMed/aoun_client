import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_catagory_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_category_model.dart';

class GetCatagoryCubit extends Cubit<BaseState<List<GetCategoryModel>>> {
  final GetCatagoryDataSource _getCatagoryDataSource;
  GetCatagoryCubit(this._getCatagoryDataSource) : super(BaseState());
  Future<void> getcatagories() async {
    emit(state.copyWith(status: Status.loading));
    final result = await _getCatagoryDataSource.getcatagory();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (data) => emit(state.copyWith(status: Status.success, data: data)),
    );
  }
}
