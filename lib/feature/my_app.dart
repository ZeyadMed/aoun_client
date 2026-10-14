import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:aoun_client/core/internet_connenction/internet_connection_state.dart';
import 'package:aoun_client/core/internet_connenction/internet_connenction_cubit.dart';
import 'package:aoun_client/core/router/app_router.dart';
import 'package:aoun_client/core/style/assets.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/core/theme/app_text_theme.dart';
import 'package:aoun_client/core/theme/text_styles.dart';
import 'package:aoun_client/core/widgets/widgets.dart';
import 'package:aoun_client/main.dart';

class TaqseetProApp extends StatelessWidget {
  const TaqseetProApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Force Arabic locale regardless of device language
    context.setLocale(const Locale('ar'));

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider(
          create: (context) => InternetCubit(),
          child: BlocBuilder<InternetCubit, InternetState>(
            builder: (context, state) {
              final bool offline = state is InternetOffState;
              return MaterialApp.router(
                title: 'عون',
                debugShowCheckedModeBanner: false,
                scaffoldMessengerKey: scaffoldMessengerKey,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: const Locale('ar'),
                theme: ThemeData(
                  useMaterial3: true,
                  fontFamily: 'Alexandria',
                  colorScheme: ColorScheme.fromSeed(
                    seedColor: AppColors.mainAppColor,
                    primary: AppColors.mainAppColor,
                    secondary: AppColors.secondaryColor,
                    error: AppColors.error,
                    surface: AppColors.bgSecondary,
                  ),
                  scaffoldBackgroundColor: AppColors.bgPrimary,
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.mainAppColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    titleTextStyle: AppTextTheme.h3.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mainAppColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      textStyle: AppTextTheme.button,
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: AppColors.bgSecondary,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.mainAppColor,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    hintStyle: AppTextTheme.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                ),
                routerConfig: AppRouter.router,
                builder: (context, child) {
                  final media = MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.noScaling);
                  if (offline) {
                    return MediaQuery(
                      data: media,
                      child: Directionality(
                        textDirection: ui.TextDirection.rtl,
                        child: Scaffold(
                          backgroundColor: AppColors.whiteColor,
                          body: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Lottie.asset(
                                  Assets.assetsSvgNoInternet,
                                  height: 200.h,
                                ),
                              ),
                              Gaps.h18(),
                              Center(
                                child: Text(
                                  'noInternet'.tr(),
                                  style: TextStyles.blackBold14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return MediaQuery(
                    data: media,
                    child: Directionality(
                      textDirection: ui.TextDirection.rtl,
                      child: child!,
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
