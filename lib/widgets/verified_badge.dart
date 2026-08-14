import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// A teal checkmark that draws itself on (design.md §6) — the small moment of
/// reassurance when a shop's reputation is revealed.
class VerifiedBadge extends StatefulWidget {
  const VerifiedBadge({
    super.key,
    this.size = 22,
    this.show = false,
  });

  final double size;

  /// When true the checkmark animates in; otherwise it renders filled.
  final bool show;

  @override
  State<VerifiedBadge> createState() => _VerifiedBadgeState();
}

class _VerifiedBadgeState extends State<VerifiedBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    if (widget.show) _controller.forward();
  }

  @override
  void didUpdateWidget(covariant VerifiedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final t = Curves.easeOut.transform(_controller.value);
          return CustomPaint(
            painter: _CheckPainter(progress: t),
          );
        },
      ),
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(size.width / 2, size.height / 2);

    final circlePaint = Paint()..color = AppColors.deepTeal;
    canvas.drawCircle(center, radius, circlePaint);

    final checkPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = radius * 0.32
      ..color = Colors.white;

    // Path from bottom-left up to the peak then down to bottom-right.
    final path = Path()
      ..moveTo(size.width * 0.27, size.height * 0.52)
      ..lineTo(size.width * 0.46, size.height * 0.70)
      ..lineTo(size.width * 0.74, size.height * 0.32);

    final metric = path.computeMetrics().first;
    final total = metric.length;
    final length = total * progress.clamp(0.0, 1.0);
    final checkPath = metric.extractPath(0, length);
    canvas.drawPath(checkPath, checkPaint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Small inline verified chip: teal dot + "Verified" label.
class VerifiedLabel extends StatelessWidget {
  const VerifiedLabel({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const VerifiedBadge(size: 16, show: true),
        const SizedBox(width: 5),
        Text(
          'Verified',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.deepTeal,
            fontSize: compact ? 11 : 12,
          ),
        ),
      ],
    );
  }
}

/// Icon avatar using a capital-T pin motif (design.md §5) when a shop has no
/// photo — keeps the brand mark tied to location finding.
class ShopAvatar extends StatelessWidget {
  const ShopAvatar({super.key, required this.icon, this.size = 52});

  final String icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.mintWash,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      alignment: Alignment.center,
      child: Text(
        icon,
        style: TextStyle(fontSize: size * 0.5),
      ),
    );
  }
}

/// Radius math helper used by painters.
double radians(double deg) => deg * math.pi / 180;
