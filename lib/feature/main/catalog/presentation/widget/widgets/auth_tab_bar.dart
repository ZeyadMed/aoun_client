import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/theme/app_colors.dart';
import 'auth_tab_item.dart';

class AuthTabBar extends StatelessWidget {
  final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  const AuthTabBar({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppColors.bgTertiary,
        borderRadius: BorderRadius.circular(11.r),
      ),
      child: Row(
        children: List.generate(
          labels.length,
          (i) => AuthTabItem(
            label: labels[i],
            active: selectedIndex == i,
            onTap: () => onChanged(i),
          ),
        ),
      ),
    );
  }
}
