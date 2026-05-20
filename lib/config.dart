import 'package:flutter/material.dart';


class ParticleSettingsNotifier extends ChangeNotifier {
  String _text = 'Flutter';
  double _fontSize = 120.0;
  TextAlign _textAlign = TextAlign.center;
  int _samplingGap = 3;

  double _dotRadius = 1.6;
  Color _dotColor = const Color(0xFFE0E8FF);
  Color _backgroundColor = const Color(0xFF050508);

  double _hoverRadius = 30.0;
  double _hoverForce = 6.0;
  double _damping = 0.88;
  double _assembleSpeed = 0.08;
  int _letterDelayMs = 180;

  double fadeInStep = 0.06;
  double scatterFactor = 0.8;
  int _rasterVersion = 0;

  String get text => _text;
  double get fontSize => _fontSize;
  TextAlign get textAlign => _textAlign;
  int get samplingGap => _samplingGap;
  double get dotRadius => _dotRadius;
  Color get dotColor => _dotColor;
  Color get backgroundColor => _backgroundColor;
  double get hoverRadius => _hoverRadius;
  double get hoverForce => _hoverForce;
  double get damping => _damping;
  double get assembleSpeed => _assembleSpeed;
  int get letterDelayMs => _letterDelayMs;
  Duration get letterInterval => Duration(milliseconds: _letterDelayMs);
  int get rasterVersion => _rasterVersion;

  void setText(String v) {
    if (_text == v) return;
    _text = v;
    _rasterVersion++;
    notifyListeners();
  }

  void setFontSize(double v) {
    if (_fontSize == v) return;
    _fontSize = v;
    _rasterVersion++;
    notifyListeners();
  }

  void setTextAlign(TextAlign v) {
    if (_textAlign == v) return;
    _textAlign = v;
    _rasterVersion++;
    notifyListeners();
  }

  void setSamplingGap(int v) {
    if (_samplingGap == v) return;
    _samplingGap = v;
    _rasterVersion++;
    notifyListeners();
  }

  set dotRadius(double v) {
    _dotRadius = v;
    notifyListeners();
  }

  set dotColor(Color v) {
    _dotColor = v;
    notifyListeners();
  }

  set backgroundColor(Color v) {
    _backgroundColor = v;
    notifyListeners();
  }

  set hoverRadius(double v) {
    _hoverRadius = v;
    notifyListeners();
  }

  set hoverForce(double v) {
    _hoverForce = v;
    notifyListeners();
  }

  set damping(double v) {
    _damping = v;
    notifyListeners();
  }

  set assembleSpeed(double v) {
    _assembleSpeed = v;
    notifyListeners();
  }

  set letterDelayMs(int v) {
    _letterDelayMs = v;
    notifyListeners();
  }

  void replay() {
    _rasterVersion++;
    notifyListeners();
  }
}