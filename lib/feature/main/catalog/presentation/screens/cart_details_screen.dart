part of '../widget/widgets.dart';

class CartDetailsScreen extends StatelessWidget {
  const CartDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetCartCubit>(
          create: (_) => getIt<GetCartCubit>()..getCart(),
        ),
        BlocProvider<CreateOrderCubit>(
          create: (_) => getIt<CreateOrderCubit>(),
        ),
      ],
      child: const _CartDetailsView(),
    );
  }
}

class _CartDetailsView extends StatelessWidget {
  const _CartDetailsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.mainAppColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'تفاصيل السلة',
          style: AppTextTheme.h4.copyWith(color: Colors.white, fontSize: 16.sp),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          BlocBuilder<GetCartCubit, BaseState<CartModel>>(
            builder: (context, state) {
              final hasItems = (state.data?.items.isNotEmpty ?? false);
              if (!hasItems) return const SizedBox.shrink();
              return IconButton(
                tooltip: 'تفريغ السلة',
                icon: const Icon(Icons.delete_sweep_outlined),
                onPressed: () => _confirmClearCart(context),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<GetCartCubit, BaseState<CartModel>>(
        builder: (context, state) {
          if (state.status == Status.loading ||
              state.status == Status.initial) {
            return const CartShimmer();
          }
          if (state.status == Status.failure) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 60.h),
              child: FailureWidget(
                errorMessage: state.errorMessage ?? 'حدث خطأ ما',
                onRetry: () async => context.read<GetCartCubit>().getCart(),
              ),
            );
          }

          final cart = state.data;
          final items = cart?.items ?? const [];

          if (items.isEmpty) return const CartEmptyState();

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.all(12.w),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => SizedBox(height: 10.h),
                  itemBuilder: (_, i) => CartItemTile(
                    item: items[i],
                    onEdit: () => _openEditDialog(context, items[i]),
                    onDelete: () => _confirmDeleteItem(context, items[i]),
                  ),
                ),
              ),
              CartSummary(
                cart: cart!,
                onCompleteOrder: () => _openPlaceOrderDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }

  // ─── Edit ────────────────────────────────────────────────────────
  void _openEditDialog(BuildContext context, CartItemModel item) {
    final cubit = context.read<GetCartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (_) => PaymentMethodDialog(
        productId: item.productId,
        initialQuantity: item.quantity,
        maxQuantity: 99,
        initialPaymentMethod: item.isInstallment
            ? OrderPaymentMethod.installment
            : OrderPaymentMethod.cash,
        initialInstallmentMonths: item.installmentMonths ?? 6,
        title: 'تعديل المنتج',
        onConfirm: (method, months, quantity) async {
          final result = await cubit.updateItem(
            item.id,
            UpdateCartItemModel(
              quantity: quantity,
              paymentMethod: method,
              installmentMonths: method == OrderPaymentMethod.cash ? 0 : months,
            ),
          );
          _showResultSnack(messenger, result, 'تم تعديل المنتج بنجاح');
        },
      ),
    );
  }

  // ─── Delete one ──────────────────────────────────────────────────
  void _confirmDeleteItem(BuildContext context, CartItemModel item) {
    final cubit = context.read<GetCartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    ConfirmDialog.show(
      context: context,
      title: 'حذف المنتج',
      message: 'هل تريد حذف "${item.productName}" من السلة؟',
      confirmLabel: 'حذف',
      icon: Icons.delete_outline_rounded,
      onConfirm: () async {
        final result = await cubit.deleteItem(item.id);
        _showResultSnack(messenger, result, 'تم حذف المنتج من السلة');
      },
    );
  }

  // ─── Clear all ───────────────────────────────────────────────────
  void _confirmClearCart(BuildContext context) {
    final cubit = context.read<GetCartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    ConfirmDialog.show(
      context: context,
      title: 'تفريغ السلة',
      message: 'هل تريد حذف كل المنتجات من السلة؟',
      confirmLabel: 'تفريغ',
      icon: Icons.remove_shopping_cart_outlined,
      onConfirm: () async {
        final result = await cubit.clearCart();
        _showResultSnack(messenger, result, 'تم تفريغ السلة');
      },
    );
  }

  // ─── Place order ─────────────────────────────────────────────────
  void _openPlaceOrderDialog(BuildContext context) {
    final orderCubit = context.read<CreateOrderCubit>();
    final cartCubit = context.read<GetCartCubit>();
    final messenger = ScaffoldMessenger.of(context);
    PlaceOrderDialog.show(
      context: context,
      onConfirm: (request) async {
        final result = await orderCubit.createOrder(request);
        result.fold(
          (failure) {
            messenger.showSnackBar(
              SnackBar(
                content: Text(failure.message),
                backgroundColor: AppColors.error,
              ),
            );
          },
          (_) {
            cartCubit.getCart();
            messenger.showSnackBar(
              SnackBar(
                content: const Text('تم تأكيد الطلبية بنجاح'),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/home');
          },
        );
      },
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────
  void _showResultSnack(
    ScaffoldMessengerState messenger,
    Either<Failure, Null> result,
    String successMessage,
  ) {
    result.fold(
      (failure) => messenger.showSnackBar(
        SnackBar(
          content: Text(failure.message),
          backgroundColor: AppColors.error,
        ),
      ),
      (_) => messenger.showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: AppColors.success,
        ),
      ),
    );
  }
}
