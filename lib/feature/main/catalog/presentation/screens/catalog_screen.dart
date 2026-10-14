part of '../widget/widgets.dart';

class CatalogScreen extends StatelessWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetProductCubit>(
          create: (_) => getIt<GetProductCubit>()
            ..add(const LoadFirstPage<GetProductModel>()),
        ),
        BlocProvider<GetCartCubit>(
          create: (_) => getIt<GetCartCubit>()..getCart(),
        ),
      ],
      child: const _CatalogView(),
    );
  }
}

class _CatalogView extends StatefulWidget {
  const _CatalogView();

  @override
  State<_CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<_CatalogView> {
  int _chipIdx = 0;
  final _search = TextEditingController();
  Timer? _searchDebounce;
  DateTime? _lastSearchAt;
  final _chips = [
    'catalog.all',
    'catalog.phones',
    'catalog.appliances',
    'catalog.laptops',
    'catalog.furniture',
    'catalog.screens',
  ];
  final _scroll = ScrollController();

  final Map<int, int> _cartItems = {};

  int get _cartCount => _cartItems.values.fold<int>(0, (sum, qty) => sum + qty);

  num _cartTotal(List<GetProductModel> items) => items
      .where((i) => _cartItems.containsKey(i.id))
      .fold<num>(0, (s, i) => s + (i.cashPrice * (_cartItems[i.id] ?? 0)));

  void _increment(GetProductModel item) {
    final currentQty = _cartItems[item.id] ?? 0;
    final remaining = item.availableQuantity - currentQty;
    if (remaining <= 0) return;
    showDialog(
      context: context,
      builder: (ctx) => PaymentMethodDialog(
        productId: item.id,
        initialQuantity: 1,
        maxQuantity: remaining,
        onConfirm: (paymentMethod, months, quantity) {
          _addToCart(
            productId: item.id,
            quantity: quantity,
            paymentMethod: paymentMethod,
            installmentMonths: months,
          );
        },
      ),
    );
  }

  Future<void> _addToCart({
    required int productId,
    required int quantity,
    required OrderPaymentMethod paymentMethod,
    required int installmentMonths,
  }) async {
    final request = AddToCartModel(
      productId: productId,
      quantity: quantity,
      paymentMethod: paymentMethod,
      installmentMonths: installmentMonths,
    );

    final result = await getIt<GenericDataSource>().postData<Null>(
      endpoint: Endpoints.addToCart,
      data: request.toJson(),
    );

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      (success) {
        setState(() {
          final current = _cartItems[productId] ?? 0;
          if (current < 100) {
            _cartItems[productId] = current + quantity;
          }
        });
        if (mounted) {
          context.read<GetCartCubit>().getCart();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تمت الإضافة للسلة بنجاح'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      },
    );
  }

  void _decrement(int productId) {
    setState(() {
      final current = _cartItems[productId] ?? 0;
      if (current <= 1) {
        _cartItems.remove(productId);
      } else {
        _cartItems[productId] = current - 1;
      }
    });
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();

    final now = DateTime.now();
    final shouldThrottle =
        _lastSearchAt != null &&
        now.difference(_lastSearchAt!) < const Duration(milliseconds: 800);

    final delay = shouldThrottle
        ? const Duration(milliseconds: 800)
        : const Duration(milliseconds: 400);

    _searchDebounce = Timer(delay, () {
      if (!mounted) return;
      _lastSearchAt = DateTime.now();
      context.read<GetProductCubit>().add(
        LoadFirstPage<GetProductModel>(
          params: _chipIdx,
          query: {'search': value.trim()},
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _scroll.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scroll.hasClients) return;
    if (_scroll.position.pixels >= _scroll.position.maxScrollExtent - 200) {
      final cubit = context.read<GetProductCubit>();
      final status = cubit.state.status;
      if (status != Status.isLoadingMore && status != Status.loading) {
        cubit.add(const LoadNextPage<GetProductModel>());
      }
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scroll.removeListener(_onScroll);
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _syncCartFromApi(CartModel? cart) {
    final apiMap = <int, int>{
      for (final item in cart?.items ?? const <CartItemModel>[])
        item.productId: item.quantity,
    };
    if (apiMap.length == _cartItems.length &&
        apiMap.entries.every((e) => _cartItems[e.key] == e.value)) {
      return;
    }
    setState(() {
      _cartItems
        ..clear()
        ..addAll(apiMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocListener<GetCartCubit, BaseState<CartModel>>(
        listenWhen: (prev, curr) => prev.data != curr.data,
        listener: (_, cartState) => _syncCartFromApi(cartState.data),
        child: BlocBuilder<GetProductCubit, BaseState<GetProductModel>>(
          builder: (context, state) {
            final items = state.items;
            final cartTotal = _cartTotal(items);

            return Stack(
              children: [
                Column(
                  children: [
                    BlocBuilder<GetCartCubit, BaseState<CartModel>>(
                      builder: (context, cartState) {
                        final badgeCount = cartState.data != null
                            ? cartState.data!.totalItems
                            : _cartCount;
                        return CatalogHeader(
                          cartCount: badgeCount,
                          searchController: _search,
                          onSearchChanged: _onSearchChanged,
                        );
                      },
                    ),
                  Expanded(
                    child: BouncingRefresh(
                      onRefresh: () async {
                        context.read<GetProductCubit>().add(
                          LoadFirstPage<GetProductModel>(
                            params: _chipIdx,
                            query: {'search': _search.text.trim()},
                          ),
                        );
                      },
                      child: ListView(
                        controller: _scroll,
                        padding: EdgeInsets.all(10.w),
                        children: [
                          CategoryChips(
                            chips: _chips,
                            selected: _chipIdx,
                            onSelect: (i) {
                              setState(() => _chipIdx = i);
                              context.read<GetProductCubit>().add(
                                LoadFirstPage<GetProductModel>(params: i),
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          if (state.status == Status.loading ||
                              state.status == Status.initial)
                            const ProductsShimmer()
                          else if (state.status == Status.failure)
                            Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: FailureWidget(
                                errorMessage:
                                    state.errorMessage ?? 'حدث خطأ ما',
                                onRetry: () async =>
                                    context.read<GetProductCubit>().add(
                                      LoadFirstPage<GetProductModel>(
                                        params: _chipIdx,
                                      ),
                                    ),
                              ),
                            )
                          else if (items.isEmpty)
                            Padding(
                              padding: EdgeInsets.only(top: 60.h),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade500,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.production_quantity_limits,
                                      color: AppColors.primaryColor,
                                      size: 30,
                                    ),
                                  ),
                                  Gap(10),
                                  Text(
                                    'لا توجد منتجات',
                                    style: AppTextTheme.bodyMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 10.h,
                                    crossAxisSpacing: 10.w,
                                    mainAxisExtent: 360.h,
                                  ),
                              itemBuilder: (_, i) {
                                final item = items[i];
                                final qty = _cartItems[item.id] ?? 0;
                                return ProductCard(
                                  item: item,
                                  quantity: qty,
                                  onIncrement: () => _increment(item),
                                  onDecrement: () => _decrement(item.id),
                                );
                              },
                            ),
                          if (state.status == Status.isLoadingMore)
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: const Center(
                                child: SizedBox(
                                  height: 60,
                                  child: BouncingBallRefreshIndicator(
                                    progress: 1.0,
                                    isRefreshing: true,
                                  ),
                                ),
                              ),
                            ),
                          SizedBox(height: 100.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_cartCount > 0)
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: GestureDetector(
                    onTap: () => context.push('/catalog/cart'),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.mainAppColor,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainAppColor.withValues(
                              alpha: 0.35,
                            ),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.push('/catalog/cart'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              minimumSize: Size.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            child: Text(
                              'catalog.complete_order'.tr(),
                              style: AppTextTheme.captionBold.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'catalog.cart_count'.tr(
                                  namedArgs: {'count': '$_cartCount'},
                                ),
                                style: AppTextTheme.labelMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'catalog.cart_total'.tr(
                                  namedArgs: {
                                    'total': cartTotal.toStringAsFixed(0),
                                  },
                                ),
                                style: AppTextTheme.caption.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(22.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Container(
                  width: 90.w,
                  height: 90.h,
                  decoration: const BoxDecoration(
                    color: AppColors.mainLight,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_outline,
                    color: AppColors.mainAppColor,
                    size: 44.sp,
                  ),
                ),
                SizedBox(height: 18.h),
                Text(
                  'catalog.order_success_title'.tr(),
                  style: AppTextTheme.h1,
                ),
                SizedBox(height: 10.h),
                Text(
                  'catalog.order_success_sub'.tr(),
                  style: AppTextTheme.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'catalog.order_summary'.tr(),
                          style: AppTextTheme.labelSmall,
                        ),
                        Divider(color: AppColors.border, height: 14.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '4,000 ج.م',
                              style: AppTextTheme.labelMedium.copyWith(
                                color: AppColors.mainAppColor,
                              ),
                            ),
                            Text(
                              'iPhone 15 + Samsung S25',
                              style: AppTextTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '292 ج.م × 12',
                              style: AppTextTheme.labelMedium.copyWith(
                                color: AppColors.accentTeal,
                              ),
                            ),
                            Text(
                              'catalog.expected_installment'.tr(),
                              style: AppTextTheme.bodySmall,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#ORD-2025-04-0045',
                              style: AppTextTheme.labelSmall,
                            ),
                            Text(
                              'catalog.order_no'.tr(),
                              style: AppTextTheme.caption,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(14.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('catalog.what_next'.tr(), style: AppTextTheme.h4),
                        SizedBox(height: 10.h),
                        _step(
                          '1',
                          'catalog.step1_title'.tr(),
                          'catalog.step1_desc'.tr(),
                          AppColors.warning,
                          AppColors.warningLight,
                        ),
                        _step(
                          '2',
                          'catalog.step2_title'.tr(),
                          'catalog.step2_desc'.tr(),
                          AppColors.mainAppColor,
                          AppColors.mainLight,
                        ),
                        _step(
                          '3',
                          'catalog.step3_title'.tr(),
                          'catalog.step3_desc'.tr(),
                          AppColors.success,
                          AppColors.successLight,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whatsappLight,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'payments.whatsapp_sent'.tr(),
                            style: AppTextTheme.labelSmall.copyWith(
                              color: const Color(0xFF1A5E32),
                            ),
                          ),
                          Text(
                            '+966 501234567',
                            style: AppTextTheme.caption.copyWith(
                              color: const Color(0xFF2E7D32),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 36.w,
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: AppColors.whatsapp,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text('common.back'.tr(), style: AppTextTheme.button),
                ),
                SizedBox(height: 8.h),
                OutlinedButton(
                  onPressed: () => context.go('/catalog'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.mainAppColor),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    'catalog.continue_shopping'.tr(),
                    style: AppTextTheme.button.copyWith(
                      color: AppColors.mainAppColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _step(String n, String title, String desc, Color col, Color bg) =>
      Padding(
        padding: EdgeInsets.only(bottom: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(title, style: AppTextTheme.labelMedium),
                  Text(desc, style: AppTextTheme.caption.copyWith(height: 1.5)),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 24.w,
              height: 24.h,
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Center(
                child: Text(
                  n,
                  style: AppTextTheme.captionBold.copyWith(color: col),
                ),
              ),
            ),
          ],
        ),
      );
}
