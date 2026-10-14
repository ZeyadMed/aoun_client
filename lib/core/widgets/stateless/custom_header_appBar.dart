import '../../extensions/extensions.dart';
import '../../theme/app_colors.dart';
import '../widgets.dart';
import 'package:flutter/material.dart';

class CustomHeaderAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  const CustomHeaderAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      height: context.screenHeight * 0.1,
      width: double.infinity,
      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: LocalizedLabel(
                text: title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (showBackButton)
              Positioned(
                left: isRtl ? null : 16,
                right: isRtl ? 16 : null,
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    isRtl ? Icons.arrow_back : Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
