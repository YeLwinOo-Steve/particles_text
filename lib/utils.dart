import 'dart:math';

/// Euclidean distance between two points given as deltas (dx, dy)
double _euclideanDistance(double dx, double dy) {
  return sqrt(dx * dx + dy * dy);
}

/// Unit direction along (dx, dy), or null when distance is zero
(double nx, double ny)? unitDirection(double dx, double dy) {
  final dist = _euclideanDistance(dx, dy);
  if (dist == 0) return null;
  return (dx / dist, dy / dist);
}

/// Radial impulse along (dx, dy) with linear falloff from [force] at the
/// origin to zero at [radius]. Returns null when outside the radius or at zero distance
(double dvx, double dvy)? radialFalloffImpulse({
  required double dx,
  required double dy,
  required double radius,
  required double force,
}) {
  final dist = _euclideanDistance(dx, dy);
  if (dist >= radius || dist <= 0) return null;
  final strength = (1 - dist / radius) * force;
  final dir = unitDirection(dx, dy)!;
  return (dir.$1 * strength, dir.$2 * strength);
}
