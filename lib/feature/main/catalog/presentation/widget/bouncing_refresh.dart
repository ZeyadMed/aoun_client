part of 'widgets.dart';

/// Pull-to-refresh wrapper that uses [BouncingBallRefreshIndicator]
/// instead of the default Material spinner.
class BouncingRefresh extends StatefulWidget {
  final Future<void> Function() onRefresh;
  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry padding;

  const BouncingRefresh({
    super.key,
    required this.onRefresh,
    required this.child,
    this.controller,
    this.padding = EdgeInsets.zero,
  });

  @override
  State<BouncingRefresh> createState() => _BouncingRefreshState();
}

class _BouncingRefreshState extends State<BouncingRefresh> {
  static const double _triggerDistance = 80;

  double _drag = 0;
  bool _isRefreshing = false;

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      await widget.onRefresh();
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
          _drag = 0;
        });
      }
    }
  }

  bool _onNotification(ScrollNotification n) {
    if (_isRefreshing) return false;
    if (n is OverscrollNotification && n.overscroll < 0) {
      setState(() {
        _drag = (_drag - n.overscroll).clamp(0.0, _triggerDistance * 1.6);
      });
    } else if (n is ScrollUpdateNotification) {
      if (n.metrics.pixels <= 0 && (n.dragDetails?.delta.dy ?? 0) > 0) {
        setState(() {
          _drag = (_drag + (n.dragDetails!.delta.dy))
              .clamp(0.0, _triggerDistance * 1.6);
        });
      } else if (n.metrics.pixels > 0 && _drag > 0) {
        setState(() => _drag = 0);
      }
    } else if (n is ScrollEndNotification) {
      if (_drag >= _triggerDistance) {
        _handleRefresh();
      } else if (_drag > 0) {
        setState(() => _drag = 0);
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_drag / _triggerDistance).clamp(0.0, 1.0);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: widget.padding,
          child: NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: widget.child,
          ),
        ),
        if (_drag > 0 || _isRefreshing)
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60,
              child: BouncingBallRefreshIndicator(
                progress: progress,
                isRefreshing: _isRefreshing,
              ),
            ),
          ),
      ],
    );
  }
}
