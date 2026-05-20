import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config.dart';
import '../constants.dart';
import 'particle_canvas.dart';
import 'side_panel.dart';

class ParticleTextPage extends StatefulWidget {
  const ParticleTextPage({super.key});

  @override
  State<ParticleTextPage> createState() => _ParticleTextPageState();
}

class _ParticleTextPageState extends State<ParticleTextPage> {
  final _settings = ParticleSettingsNotifier();
  final _panelOpen = ValueNotifier(true);

  Future<void> _openGitHub() async {
    final uri = Uri.parse(kGitHubRepoUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open GitHub')));
    }
  }

  @override
  void dispose() {
    _settings.dispose();
    _panelOpen.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) => Scaffold(
        backgroundColor: _settings.backgroundColor,
        body: Row(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _panelOpen,
              builder: (_, open, __) => AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                width: open ? kPanelWidth : 0,
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(),
                child: open
                    ? OverflowBox(
                        minWidth: kPanelWidth,
                        maxWidth: kPanelWidth,
                        alignment: Alignment.centerLeft,
                        child: SidePanel(
                          settings: _settings,
                          panelOpen: _panelOpen,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ),

            Expanded(
              child: Stack(
                children: [
                  ParticleCanvas(settings: _settings),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Row(
                      children: [
                        ValueListenableBuilder<bool>(
                          valueListenable: _panelOpen,
                          builder: (_, open, __) => _CanvasIconButton(
                            icon: open
                                ? Icons.chevron_left
                                : Icons.chevron_right,
                            onTap: () => _panelOpen.value = !open,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _CanvasIconButton(
                          icon: Icons.replay,
                          onTap: _settings.replay,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _CanvasIconButton(
                      icon: SimpleIcons.github,
                      onTap: _openGitHub,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CanvasIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CanvasIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: Colors.white54),
      ),
    );
  }
}
