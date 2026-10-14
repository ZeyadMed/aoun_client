import 'package:aoun_client/core/bloc/paginated_bloc/exports.dart';
import 'package:aoun_client/core/params/params.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_product_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/model/get_product_model.dart';

class GetProductCubit extends PaginatedBloc<GetProductModel> {
  final GetProductDataSource getProductUseCase;

  GetProductCubit(this.getProductUseCase)
    : super(
        fetchPage: (page, limit, query, params) {
          final categoryId = params is int ? params : 0;
          final search = query?['search'] as String?;
          return getProductUseCase.getProduct(
            query: search,
            params: PaginationParams(page: page, limit: limit),
            categoryId: categoryId,
          );
        },
        cacheKeyBuilder: (params, query) {
          final categoryId = params is int ? params : 0;
          return 'get_product_$categoryId';
        },
      );
}
