import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../core/http/http.dart';
import '../../../core/local_storage/local_storage.dart';
import '../../../core/router/app_router.dart';
import '../../../core/service_locator/service_locator.dart';
import '../../../core/style/assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // One-shot entrance animation (logo → title → subtitle → loader).
  late final AnimationController _entryCtrl;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotate;
  late final Animation<double> _logoFade;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _loaderFade;

  // Continuous ambient loop (glow pulse + floating circles + gradient drift).
  late final AnimationController _loopCtrl;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _logoScale = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );
    _logoRotate = Tween<double>(begin: -0.35, end: 0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _logoFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    );

    _titleFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.45, 0.7, curve: Curves.easeIn),
    );
    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.45, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _subtitleFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.6, 0.85, curve: Curves.easeIn),
    );
    _subtitleSlide =
        Tween<Offset>(begin: const Offset(0, 0.8), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.6, 0.9, curve: Curves.easeOutCubic),
          ),
        );

    _loaderFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.8, 1.0, curve: Curves.easeIn),
    );

    _loopCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _entryCtrl.forward();

    Future.delayed(const Duration(seconds: 3), () async {
      if (!mounted) return;
      await _resolveStartRoute();
    });
  }

  Future<void> _resolveStartRoute() async {
    final token = HiveServiceImpl.instance.getAccessToken();

    // 1) مفيش توكن خالص → onboarding
    if (token == null || token.refreshToken.isEmpty) {
      if (!mounted) return;
      context.go(AppRouter.onboarding);
      return;
    }

    final isAccessValid =
        token.accessToken.isNotEmpty &&
        token.expiresAtUtc.isAfter(DateTime.now().toUtc());
    if (isAccessValid) {
      getIt<Dio>().options.headers['Authorization'] =
          'Bearer ${token.accessToken}';
      if (!mounted) return;
      context.go(AppRouter.home);
      return;
    }

    final refreshed = await getIt<ApiConsumer>().refreshToken();
    if (!mounted) return;
    if (refreshed) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.login);
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _loopCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _loopCtrl,
        builder: (context, child) {
          final t = _loopCtrl.value; // 0..1, ping-pongs
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.lerp(
                    AppColors.mainGradient.colors.first,
                    AppColors.mainAppColor,
                    t,
                  )!,
                  Color.lerp(
                    AppColors.mainAppColor,
                    Colors.black,
                    t * 0.25,
                  )!,
                ],
              ),
            ),
            child: child,
          );
        },
        child: Stack(
          children: [
            // Floating decorative circles.
            AnimatedBuilder(
              animation: _loopCtrl,
              builder: (context, _) {
                final t = _loopCtrl.value;
                return Stack(
                  children: [
                    Positioned(
                      top: -80.h + (10.h * t),
                      right: -80.w - (12.w * t),
                      child: Transform.rotate(
                        angle: t * math.pi,
                        child: _circle(240.w, 0.07),
                      ),
                    ),
                    Positioned(
                      bottom: -50.h - (14.h * t),
                      left: -50.w + (10.w * t),
                      child: Transform.rotate(
                        angle: -t * math.pi,
                        child: _circle(180.w, 0.05),
                      ),
                    ),
                    Positioned(
                      top: 120.h + (18.h * (1 - t)),
                      left: 30.w,
                      child: _circle(70.w, 0.06),
                    ),
                  ],
                );
              },
            ),

            // Center content.
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Plain logo with entrance animation only.
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: AnimatedBuilder(
                        animation: _logoRotate,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _logoRotate.value,
                            child: child,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.all(20.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            Assets.assetsImagesAounLogo,
                            width: 170.w,
                            height: 170.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Title.
                  FadeTransition(
                    opacity: _titleFade,
                    child: SlideTransition(
                      position: _titleSlide,
                      child: Text(
                        'عون',
                        style: AppTextTheme.display1.copyWith(
                          color: Colors.white,
                          fontSize: 30.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // Subtitle.
                  FadeTransition(
                    opacity: _subtitleFade,
                    child: SlideTransition(
                      position: _subtitleSlide,
                      child: Text(
                        'اشتري الآن، ادفع بالأقساط',
                        style: AppTextTheme.bodyMedium.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom loading indicator.
            Positioned(
              bottom: 60.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _loaderFade,
                child: Center(child: _LoadingDots(controller: _loopCtrl)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circle(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: Colors.white.withValues(alpha: opacity),
        width: size * 0.18,
      ),
    ),
  );
}

/// Three dots that scale in sequence, driven by the ambient loop controller.
class _LoadingDots extends StatelessWidget {
  const _LoadingDots({required this.controller});

  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Stagger each dot's phase across the loop.
            final phase = (controller.value + (i * 0.2)) % 1.0;
            final scale = 0.6 + (math.sin(phase * math.pi) * 0.6);
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 9.w,
                  height: 9.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(
                      alpha: 0.4 + (scale - 0.6) * 0.6,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
