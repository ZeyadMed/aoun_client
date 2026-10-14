import '../../theme/text_styles.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
    required this.text,
    required this.image,
    this.height,
    this.weight,
  });

  final String text;
  final String image;
  final double? height;
  final double? weight;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20.h,
      children: [
        Icon(Icons.info_outline, size: 48.sp, color: Colors.orange),
        LocalizedLabel(
          text: text,
          style: TextStyles.darkRegular16.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }
}
