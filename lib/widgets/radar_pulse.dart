import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Radar-style pulse animation centred on the user's location while matching
/// (design.md §6). Expanding coral rings fading to transparent — no spinner.
class RadarPulse extends StatefulWidget {
  const RadarPulse({
    super.key,
    this.size = 220,
    this.ringColor = AppColors.signalCoral,
  });

  final double size;
  final Color ringColor;

  @override
  State<RadarPulse> createState() => _RadarPulseState();
}

class _RadarPulseState extends State<RadarPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size * 0.12;
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => CustomPaint(
          painter: _RadarPainter(
            progress: _controller.value,
            ringColor: widget.ringColor,
          ),
          child: Center(
            child: Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.signalCoral,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.signalCoral.withValues(alpha: 0.45),
                    blurRadius: dotSize * 0.9,
                    spreadRadius: dotSize * 0.25,
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

class _RadarPainter extends CustomPainter {
  _RadarPainter({required this.progress, required this.ringColor});

  final double progress;
  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    // Three staggered expanding rings.
    for (var i = 0; i < 3; i++) {
      final phase = (progress + i / 3) % 1.0;
      final radius = maxRadius * (0.15 + phase * 0.85);
      final opacity = (1 - phase).clamp(0.0, 1.0);

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = ringColor.withValues(alpha: opacity * 0.55);

      canvas.drawCircle(center, radius, paint);
    }

    // Sweep "searching" arc.
    final sweep = 2 * math.pi * progress;
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3
      ..color = ringColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 0.62),
      -math.pi / 2,
      sweep,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.ringColor != ringColor;
}
