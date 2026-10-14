import 'package:get_it/get_it.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/create_order_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_cart_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_catagory_data_source.dart';
import 'package:aoun_client/feature/main/catalog/data/data_source/get_product_data_source.dart';
import 'package:aoun_client/feature/main/catalog/presentation/bloc/create_order_cubit.dart';
import 'package:aoun_client/feature/main/catalog/presentation/bloc/get_cart_cubit.dart';
import 'package:aoun_client/feature/main/catalog/presentation/bloc/get_catagory_cubit.dart';
import 'package:aoun_client/feature/main/catalog/presentation/bloc/get_product_cubit.dart';

class GetProductServiceLocator {
  static Future<void> excute({required GetIt getIt}) async {
    getIt.registerFactory<GetProductDataSource>(
      () => GetProductDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetProductCubit>(
      () => GetProductCubit(getIt<GetProductDataSource>()),
    );
    //get catagory
    getIt.registerLazySingleton<GetCatagoryDataSource>(
      () => GetCatagoryDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetCatagoryCubit>(
      () => GetCatagoryCubit(getIt())..getcatagories(),
    );
    //get cart
    getIt.registerLazySingleton<GetCartDataSource>(
      () => GetCartDataSourceImpl(getIt()),
    );
    getIt.registerFactory<GetCartCubit>(() => GetCartCubit(getIt()));
    //create order
    getIt.registerLazySingleton<CreateOrderDataSource>(
      () => CreateOrderDataSourceImpl(getIt()),
    );
    getIt.registerFactory<CreateOrderCubit>(() => CreateOrderCubit(getIt()));
  }
}
