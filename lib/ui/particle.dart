/// A single particle that assembles into a text glyph
class Particle {
  final double restX, restY;

  final int letterIndex;

  double x, y;
  double vx = 0, vy = 0;
  bool revealed = false;
  double opacity = 0;

  Particle({
    required this.restX,
    required this.restY,
    required this.letterIndex,
    required double initialX,
    required double initialY,
  }) : x = initialX,
       y = initialY;
}
