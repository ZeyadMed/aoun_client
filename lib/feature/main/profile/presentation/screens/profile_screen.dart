import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:aoun_client/core/service_locator/service_locator.dart';
import 'package:aoun_client/core/theme/app_colors.dart';
import 'package:aoun_client/feature/main/profile/presentation/logic/get_profile_cubit.dart';
import 'package:aoun_client/feature/main/profile/presentation/widget/custom_header_profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocProvider(
              create: (context) => getIt<GetProfileCubit>()..getProfile(),
              child: CustomHeaderProfile(),
            ),
          ],
        ),
      ),
    );
  }
}
