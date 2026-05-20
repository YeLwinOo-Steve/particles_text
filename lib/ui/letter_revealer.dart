import 'package:particles_text/ui/particle.dart';

class LetterRevealer {
  int _revealed = 0;
  Duration _nextAt = Duration.zero;

  void update(
    Duration elapsed,
    List<Particle> particles,
    int totalLetters,
    Duration interval,
  ) {
    while (_revealed < totalLetters && elapsed >= _nextAt) {
      for (final p in particles) {
        if (p.letterIndex == _revealed) p.revealed = true;
      }
      _revealed++;
      _nextAt += interval;
    }
  }

  void reset() {
    _revealed = 0;
    _nextAt = Duration.zero;
  }
}
