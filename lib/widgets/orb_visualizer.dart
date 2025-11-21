import 'dart:math' as math;
import 'package:flutter/material.dart';

class OrbVisualizer extends StatefulWidget {
  final bool isActive;
  final double size;

  const OrbVisualizer({
    super.key,
    this.isActive = true,
    this.size = 200,
  });

  @override
  State<OrbVisualizer> createState() => _OrbVisualizerState();
}

class _OrbVisualizerState extends State<OrbVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _rotationAnimation = Tween<double>(begin: 0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF9B7EDE),
                  const Color(0xFFB794F6),
                  const Color(0xFFD6BCFA),
                  const Color(0xFFE9D5FF),
                  const Color(0xFFFFE5D9),
                ],
                stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9B7EDE).withOpacity(0.5),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: CustomPaint(
              painter: OrbPainter(_rotationAnimation.value),
            ),
          ),
        );
      },
    );
  }
}

class OrbPainter extends CustomPainter {
  final double rotation;

  OrbPainter(this.rotation);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw swirling patterns
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + rotation;
      final startAngle = angle;
      final sweepAngle = math.pi / 3;

      paint.color = [
        const Color(0xFF9B7EDE),
        const Color(0xFFB794F6),
        const Color(0xFFD6BCFA),
        const Color(0xFFE9D5FF),
      ][i % 4].withOpacity(0.6);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius * 0.7),
        startAngle,
        sweepAngle,
        false,
        paint,
      );
    }

    // Draw highlights
    final highlightPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withOpacity(0.3);

    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.2,
      highlightPaint,
    );
  }

  @override
  bool shouldRepaint(OrbPainter oldDelegate) {
    return oldDelegate.rotation != rotation;
  }
}

