import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/router/app_router.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_theme.dart';
import '../../../../../core/widgets/common_widget/exit_confirm_toast.dart';

class MainScreen extends StatefulWidget {
  final Widget child;

  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? _lastBackPress;
  OverlayEntry? _exitToast;

  int _idx(String path) {
    if (path.startsWith('/contracts')) return 1;
    if (path.startsWith('/catalog') || path.startsWith('/payment')) return 2;
    if (path.startsWith('/statement')) return 3;
    if (path.startsWith('/profile')) return 4;
    return 0;
  }

  Future<void> _handleBack(int idx) async {
    if (idx != 0) {
      context.go(AppRouter.home);
      return;
    }

    final now = DateTime.now();
    if (_lastBackPress != null &&
        now.difference(_lastBackPress!) < const Duration(seconds: 2)) {
      _removeExitToast();
      await SystemNavigator.pop();
      return;
    }

    _lastBackPress = now;
    _removeExitToast();
    _exitToast = ExitConfirmToast.show(context);
  }

  void _removeExitToast() {
    if (_exitToast?.mounted == true) _exitToast!.remove();
    _exitToast = null;
  }

  @override
  void dispose() {
    _removeExitToast();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final idx = _idx(location);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _handleBack(idx);
      },
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: idx,
          selectedItemColor: AppColors.mainAppColor,
          unselectedItemColor: AppColors.textHint,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTextTheme.caption.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.mainAppColor,
          ),
          unselectedLabelStyle: AppTextTheme.caption,
          onTap: (i) {
            switch (i) {
              case 0:
                context.go(AppRouter.home);
                break;
              case 1:
                context.go(AppRouter.contracts);
                break;
              case 2:
                context.go(AppRouter.catalog);
                break;
              case 3:
                context.go(AppRouter.statement);
                break;
              case 4:
                context.go(AppRouter.profile);
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: 'home.title'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.description_outlined),
              activeIcon: const Icon(Icons.description),
              label: 'contracts.title'.tr(),
            ),
            BottomNavigationBarItem(
              icon: Transform.translate(
                offset: Offset(0, -10.h),
                child: Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.mainAppColor,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainAppColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ),
              label: 'تسوق',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.receipt_long_outlined),
              activeIcon: const Icon(Icons.receipt_long),
              label: 'statement.nav_title'.tr(),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outlined),
              activeIcon: const Icon(Icons.person),
              label: 'profile.title'.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
