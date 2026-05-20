import 'dart:math';
import 'dart:ui';

import 'package:particles_text/config.dart';
import 'package:particles_text/ui/particle.dart';
import 'package:particles_text/utils.dart';


class ParticlePhysics {
  static void step(
    List<Particle> particles,
    Offset? pointer,
    ParticleSettingsNotifier s,
  ) {
    for (final p in particles) {
      if (!p.revealed) continue;

      p.opacity = min(1.0, p.opacity + s.fadeInStep);

      if (pointer != null) {
        final dx = p.x - pointer.dx;
        final dy = p.y - pointer.dy;
        final impulse = radialFalloffImpulse(
          dx: dx,
          dy: dy,
          radius: s.hoverRadius,
          force: s.hoverForce,
        );
        if (impulse != null) {
          p.vx += impulse.$1;
          p.vy += impulse.$2;
        }
      }

      p.x += p.vx;
      p.y += p.vy;

      p.vx *= s.damping;
      p.vy *= s.damping;

      p.x += (p.restX - p.x) * s.assembleSpeed;
      p.y += (p.restY - p.y) * s.assembleSpeed;
    }
  }
}