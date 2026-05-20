import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:particles_text/config.dart';
import 'package:particles_text/ui/letter_revealer.dart';
import 'package:particles_text/ui/particle.dart';
import 'package:particles_text/ui/particle_painter.dart';
import 'package:particles_text/ui/particle_physics.dart';
import 'package:particles_text/ui/text_rasterizer.dart';

class ParticleCanvas extends StatefulWidget {
  final ParticleSettingsNotifier settings;

  const ParticleCanvas({super.key, required this.settings});

  @override
  State<ParticleCanvas> createState() => _ParticleCanvasState();
}

class _ParticleCanvasState extends State<ParticleCanvas>
    with SingleTickerProviderStateMixin {
  List<Particle> _particles = [];
  final _revealer = LetterRevealer();
  late Ticker _ticker;
  Offset? _pointer;
  int _lastRasterVersion = -1;
  Size _lastSize = Size.zero;
  Size? _pendingSize;
  bool _rasterizing = false;

  ParticleSettingsNotifier get _s => widget.settings;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  Future<void> _doRasterize(Size size) async {
    if (_rasterizing) {
      _pendingSize = size;
      return;
    }
    _rasterizing = true;
    _pendingSize = null;

    final version = _s.rasterVersion;
    final particles = await TextRasterizer.rasterize(_s, size);

    if (mounted) {
      _particles = particles;
      _lastRasterVersion = version;
      _lastSize = size;
      _revealer.reset();
      _ticker.stop();
      _ticker.start();
    }
    _rasterizing = false;

    // If settings or size changed while rasterizing, go again
    if (mounted &&
        (_s.rasterVersion != _lastRasterVersion || _pendingSize != null)) {
      _doRasterize(_pendingSize ?? _lastSize);
    }
  }

  void _onTick(Duration elapsed) {
    _revealer.update(elapsed, _particles, _s.text.length, _s.letterInterval);
    ParticlePhysics.step(_particles, _pointer, _s);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        if (_lastSize != size || _lastRasterVersion != _s.rasterVersion) {
          _doRasterize(size);
        }

        return MouseRegion(
          onHover: (e) => _pointer = e.localPosition,
          onExit: (_) => _pointer = null,
          child: GestureDetector(
            onPanUpdate: (d) => _pointer = d.localPosition,
            onPanEnd: (_) => _pointer = null,
            child: CustomPaint(
              size: size,
              painter: ParticlePainter(
                particles: _particles,
                dotRadius: _s.dotRadius,
                dotColor: _s.dotColor,
              ),
            ),
          ),
        );
      },
    );
  }
}
