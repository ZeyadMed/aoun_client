import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/active_contracts_section.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/custom_late_date_widget.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/home_header_section.dart';
import 'package:aoun_client/feature/main/home/presentation/widget/recent_payments_section.dart';

import '../../../../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          // Header
          const HomeHeaderSection(),

          SliverPadding(
            padding: EdgeInsets.all(12.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const CustomLateDateWidget(),
                const ActiveContractsSection(),
                SizedBox(height: 12.h),
                const RecentPaymentsSection(),
                SizedBox(height: 80.h),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
