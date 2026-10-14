import 'package:flutter/material.dart';
import 'package:aoun_client/core/theme/app_colors.dart';

class AppLoading {
  AppLoading._();

  static void show(
    BuildContext context, {
    Color? color,
    Color? backgroundColor,
    String label = 'جاري التحميل',
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: _LoadingContent(
          color: color ?? Theme.of(context).primaryColor,
          backgroundColor: backgroundColor ?? Colors.black54,
          label: label,
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

class _LoadingContent extends StatelessWidget {
  const _LoadingContent({
    required this.color,
    required this.backgroundColor,
    required this.label,
  });

  final Color color;
  final Color backgroundColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color:  AppColors.blackColor.withValues(alpha: 0.2),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StaggeredDotsWave(color: color, size: 50),
            const SizedBox(height: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StaggeredDotsWave extends StatefulWidget {
  const _StaggeredDotsWave({required this.color, this.size = 50});

  final Color color;
  final double size;

  @override
  State<_StaggeredDotsWave> createState() => _StaggeredDotsWaveState();
}

class _StaggeredDotsWaveState extends State<_StaggeredDotsWave>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size * 0.2;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          4,
          (i) => _AnimatedDot(
            controller: _controller,
            delay: i * 0.16,
            dotSize: dotSize,
            color: widget.color,
            maxHeight: widget.size * 0.55,
          ),
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatelessWidget {
  const _AnimatedDot({
    required this.controller,
    required this.delay,
    required this.dotSize,
    required this.color,
    required this.maxHeight,
  });

  final AnimationController controller;
  final double delay;
  final double dotSize;
  final Color color;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    final offsetY =
        TweenSequence<double>([
          TweenSequenceItem(
            tween: Tween(
              begin: 0.0,
              end: -1.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
          TweenSequenceItem(
            tween: Tween(
              begin: -1.0,
              end: 0.0,
            ).chain(CurveTween(curve: Curves.easeInOut)),
            weight: 50,
          ),
        ]).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(delay, (delay + 0.6).clamp(0.0, 1.0)),
          ),
        );

    return AnimatedBuilder(
      animation: controller,
      builder: (_, child) => Transform.translate(
        offset: Offset(0, offsetY.value * maxHeight),
        child: child,
      ),
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
// إظهار اللودنج
// AppLoading.show(context);

// // إخفاء اللودنج
// AppLoading.hide(context);

// // مع خيارات
// AppLoading.show(
//   context,
//   color: AppColors.mainAppColor,
//   label: 'يتم التحميل...',
// );