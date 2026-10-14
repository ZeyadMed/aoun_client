import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import 'pages/onboarding_page_one.dart';
import 'pages/onboarding_page_three.dart';
import 'pages/onboarding_page_two.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _ctrl = PageController();
  int _page = 0;

  static const List<Widget> _pages = [
    OnboardingPageOne(),
    OnboardingPageTwo(),
    OnboardingPageThree(),
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _pages.length - 1) {
      _ctrl.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  void _previous() {
    _ctrl.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _finish() {
    if (!mounted) return;
    context.go(AppRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLast = _page == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: _finish,
                child: Text(
                  'تخطي',
                  style: AppTextTheme.bodySmall.copyWith(
                    color: AppColors.textHint,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _ctrl,
                onPageChanged: (i) => setState(() => _page = i),
                children: _pages,
              ),
            ),

            // Dots indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: i == _page ? 22.w : 8.w,
                  height: 8.h,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: i == _page
                        ? AppColors.mainAppColor
                        : AppColors.greyColor,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Buttons
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _next,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      isLast ? 'ابدأ الآن' : 'التالي',
                      style: AppTextTheme.button,
                    ),
                  ),
                  if (_page > 0) ...[
                    SizedBox(height: 10.h),
                    OutlinedButton(
                      onPressed: _previous,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.mainAppColor,
                          width: 1.2,
                        ),
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        'السابق',
                        style: AppTextTheme.button.copyWith(
                          color: AppColors.mainAppColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
