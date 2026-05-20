import 'dart:async';

import 'package:flutter/material.dart';

import '../config.dart';
import '../constants.dart';

class SidePanel extends StatefulWidget {
  final ParticleSettingsNotifier settings;
  final ValueNotifier<bool> panelOpen;

  const SidePanel({super.key, required this.settings, required this.panelOpen});

  @override
  State<SidePanel> createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  late final TextEditingController _textCtrl;
  Timer? _textDebounce;

  ParticleSettingsNotifier get _s => widget.settings;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: _s.text);
  }

  @override
  void dispose() {
    _textDebounce?.cancel();
    _textCtrl.dispose();
    super.dispose();
  }

  void _onTextChanged(String value) {
    _textDebounce?.cancel();
    _textDebounce = Timer(const Duration(milliseconds: 500), () {
      _s.setText(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: Container(
        width: kPanelWidth,
        color: kPanelBgColor,
        child: ListenableBuilder(
          listenable: _s,
          builder: (context, _) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              ..._panelHeader(),
              ..._textSection(),
              ..._particlesSection(),
              ..._hoverSection(),
              ..._physicsSection(),
              ..._colorsSection(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _panelHeader() => [
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'CONTROLS',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ), 
      ],
    ),
    const SizedBox(height: 16),
    _divider(),
  ];

  List<Widget> _textSection() => [
    _section('TEXT'),
    _label('Content'),
    _textField(),
    const SizedBox(height: 10),
    _label('Alignment'),
    _alignmentRow(),
    const SizedBox(height: 6),
    _sliderTile('Font Size', _s.fontSize, 40, 240, (v) => _s.setFontSize(v)),
    _divider(),
  ];

  List<Widget> _particlesSection() => [
    _section('PARTICLES'),
    _sliderTile('Dot Radius', _s.dotRadius, 0.5, 4.0, (v) => _s.dotRadius = v),
    _sliderTile(
      'Dot Spacing',
      _s.samplingGap.toDouble(),
      1,
      8,
      (v) => _s.setSamplingGap(v.round()),
    ),
    _divider(),
  ];

  List<Widget> _hoverSection() => [
    _section('HOVER'),
    _sliderTile('Radius', _s.hoverRadius, 10, 150, (v) => _s.hoverRadius = v),
    _sliderTile('Force', _s.hoverForce, 1, 20, (v) => _s.hoverForce = v),
    _divider(),
  ];

  List<Widget> _physicsSection() => [
    _section('PHYSICS'),
    _sliderTile('Damping', _s.damping, 0.5, 1.0, (v) => _s.damping = v),
    _sliderTile(
      'Assembly Speed',
      _s.assembleSpeed,
      0.01,
      0.3,
      (v) => _s.assembleSpeed = v,
    ),
    _sliderTile(
      'Letter Delay (ms)',
      _s.letterDelayMs.toDouble(),
      20,
      500,
      (v) => _s.letterDelayMs = v.round(),
    ),
    _divider(),
  ];

  List<Widget> _colorsSection() => [
    _section('COLORS'),
    _label('Dot Color'),
    const SizedBox(height: 4),
    _colorSwatches(_s.dotColor, (c) => _s.dotColor = c),
    const SizedBox(height: 12),
    _label('Background'),
    const SizedBox(height: 4),
    _colorSwatches(_s.backgroundColor, (c) => _s.backgroundColor = c),
    const SizedBox(height: 24),
  ];

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 8),
    child: Text(
      title,
      style: const TextStyle(
        color: Colors.white24,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    ),
  );

  Widget _label(String text) =>
      Text(text, style: const TextStyle(color: Colors.white54, fontSize: 12));

  Widget _divider() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Divider(color: Colors.white.withValues(alpha: 0.06), height: 1),
  );

  Widget _textField() => TextField(
    controller: _textCtrl,
    style: const TextStyle(color: Colors.white, fontSize: 13),
    decoration: InputDecoration(
      hintText: 'Enter text',
      hintStyle: const TextStyle(color: Colors.white24, fontSize: 13),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.white24),
      ),
    ),
    onChanged: _onTextChanged,
  );

  Widget _sliderTile(
    String label,
    double value,
    double lo,
    double hi,
    ValueChanged<double> onChanged,
  ) {
    final display = value < 1
        ? value.toStringAsFixed(2)
        : value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ),
              Text(
                display,
                style: const TextStyle(color: Colors.white30, fontSize: 11),
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: SliderTheme(
              data: SliderThemeData(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: Colors.white24,
                inactiveTrackColor: Colors.white10,
                thumbColor: Colors.white54,
                overlayColor: Colors.white.withValues(alpha: 0.08),
              ),
              child: Slider(
                value: value.clamp(lo, hi),
                min: lo,
                max: hi,
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _alignmentRow() {
    return Row(
      children: [
        _alignBtn(Icons.format_align_left, TextAlign.left),
        const SizedBox(width: 6),
        _alignBtn(Icons.format_align_center, TextAlign.center),
        const SizedBox(width: 6),
        _alignBtn(Icons.format_align_right, TextAlign.right),
      ],
    );
  }

  Widget _alignBtn(IconData icon, TextAlign align) {
    final active = _s.textAlign == align;
    return GestureDetector(
      onTap: () => _s.setTextAlign(align),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: active ? Colors.white12 : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: active ? Colors.white30 : Colors.white10),
        ),
        child: Icon(
          icon,
          size: 16,
          color: active ? Colors.white70 : Colors.white30,
        ),
      ),
    );
  }

  Widget _colorSwatches(Color current, ValueChanged<Color> onPick) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: kColorPresets.map((c) {
        final selected = current == c;
        return GestureDetector(
          onTap: () => onPick(c),
          child: Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: c,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? Colors.white : Colors.white24,
                width: selected ? 2 : 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
