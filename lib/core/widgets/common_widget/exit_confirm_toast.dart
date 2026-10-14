import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_text_theme.dart';

class ExitConfirmToast extends StatelessWidget {
  final String message;

  const ExitConfirmToast({super.key, this.message = 'اضغط مرة أخرى للخروج'});

  static OverlayEntry? show(
    BuildContext context, {
    String message = 'اضغط مرة أخرى للخروج',
    Duration autoDismissAfter = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return null;

    late OverlayEntry entry;
    entry = OverlayEntry(builder: (_) => ExitConfirmToast(message: message));

    overlay.insert(entry);

    Future.delayed(autoDismissAfter, () {
      if (entry.mounted) entry.remove();
    });

    return entry;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: MediaQuery.of(context).size.height * 0.18,
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutBack,
            builder: (_, value, child) => Opacity(
              opacity: value.clamp(0.0, 1.0),
              child: Transform.scale(scale: 0.9 + (value * 0.1), child: child),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: AppTextTheme.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
