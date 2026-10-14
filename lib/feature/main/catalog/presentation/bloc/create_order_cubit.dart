import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/enum/status.dart';
import 'package:aoun_client/core/http/either.dart';
import 'package:aoun_client/core/http/failure.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/create_order_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/model/create_order_model.dart';

class CreateOrderCubit extends Cubit<BaseState<Null>> {
  final CreateOrderDataSource _dataSource;
  CreateOrderCubit(this._dataSource) : super(const BaseState());

  Future<Either<Failure, Null>> createOrder(CreateOrderModel request) async {
    emit(state.copyWith(status: Status.loading));
    final result = await _dataSource.createOrder(request);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: Status.success)),
    );
    return result;
  }
}
