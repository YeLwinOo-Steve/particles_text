import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:particles_text/config.dart';
import 'package:particles_text/ui/particle.dart';


class TextRasterizer {
  static Future<List<Particle>> rasterize(
    ParticleSettingsNotifier s,
    Size canvasSize,
  ) async {
    final paragraph = _buildParagraph(s, canvasSize.width);
    final offset = _computeOffset(paragraph, canvasSize, s.textAlign);
    final pixels = await _renderToPixels(paragraph, offset, canvasSize);
    if (pixels == null) return [];

    final letterRects = _getLetterRects(paragraph, s.text, offset);

    return _sampleParticles(
      pixels: pixels,
      width: canvasSize.width.ceil(),
      height: canvasSize.height.ceil(),
      letterRects: letterRects,
      canvasSize: canvasSize,
      gap: s.samplingGap,
      scatter: s.scatterFactor,
    );
  }

  static ui.Paragraph _buildParagraph(
    ParticleSettingsNotifier s,
    double maxWidth,
  ) {
    final style = ui.TextStyle(
      color: Colors.white,
      fontSize: s.fontSize,
      fontWeight: FontWeight.w900,
    );
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.left,
      fontSize: s.fontSize,
      fontWeight: FontWeight.w900,
    ))
      ..pushStyle(style)
      ..addText(s.text);

    return builder.build()
      ..layout(ui.ParagraphConstraints(width: maxWidth));
  }

  static Offset _computeOffset(
    ui.Paragraph p,
    Size canvas,
    TextAlign align,
  ) {

    // center vertically
    final dy = (canvas.height - p.height) / 2;
    final textW = p.longestLine > 0 ? p.longestLine : p.maxIntrinsicWidth;
    double dx;
    switch (align) {
      case TextAlign.left:
      case TextAlign.start:
        dx = 24;
      case TextAlign.right:
      case TextAlign.end:
        dx = canvas.width - textW - 24;
      default:
        dx = (canvas.width - textW) / 2;
    }
    return Offset(dx.clamp(0, canvas.width), dy);
  }

  static Future<Uint8List?> _renderToPixels(
    ui.Paragraph paragraph,
    Offset offset,
    Size canvasSize,
  ) async {
    final recorder = ui.PictureRecorder();
    Canvas(recorder).drawParagraph(paragraph, offset);
    final picture = recorder.endRecording();
    final image = picture.toImageSync(
      canvasSize.width.ceil(),
      canvasSize.height.ceil(),
    );
    final byteData = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    image.dispose();
    return byteData?.buffer.asUint8List();
  }

  static List<Rect> _getLetterRects(
    ui.Paragraph paragraph,
    String text,
    Offset offset,
  ) {
    return List.generate(text.length, (i) {
      final boxes = paragraph.getBoxesForRange(i, i + 1);
      if (boxes.isEmpty) return Rect.zero;
      return boxes.first.toRect().shift(offset);
    });
  }

  static List<Particle> _sampleParticles({
    required Uint8List pixels,
    required int width,
    required int height,
    required List<Rect> letterRects,
    required Size canvasSize,
    required int gap,
    required double scatter,
  }) {
    final rng = Random();
    final particles = <Particle>[];

    for (int py = 0; py < height; py += gap) {
      for (int px = 0; px < width; px += gap) {
        // RGBA indexes
        final idx = (py * width + px) * 4;
        // skip pixels out of bounds
        if (idx + 3 >= pixels.length) continue;
        // skip pixels with opacity < 50%
        if (pixels[idx + 3] < 128) continue;

        final li = _findLetterIndex(px.toDouble(), letterRects);
        particles.add(Particle(
          restX: px.toDouble(),
          restY: py.toDouble(),
          letterIndex: li,
          initialX:
              px + (rng.nextDouble() - 0.5) * canvasSize.width * scatter,
          initialY:
              py + (rng.nextDouble() - 0.5) * canvasSize.height * scatter,
        ));
      }
    }
    return particles;
  }

  static int _findLetterIndex(double x, List<Rect> rects) {
    for (int i = 0; i < rects.length; i++) {
      if (x >= rects[i].left && x < rects[i].right) return i;
    }
    return 0;
  }
}