import 'package:flutter/material.dart';
import 'package:particles_text/ui/particle.dart';


class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double dotRadius;
  final Color dotColor;

  const ParticlePainter({
    required this.particles,
    required this.dotRadius,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    for (final p in particles) {
      if (!p.revealed || p.opacity <= 0) continue;
      paint.color = dotColor.withValues(alpha: p.opacity * 0.85);
      canvas.drawCircle(Offset(p.x, p.y), dotRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant ParticlePainter old) => true;
}