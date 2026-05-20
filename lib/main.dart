import 'package:flutter/material.dart';

import 'ui/particle_text_page.dart';

void main() => runApp(const ParticleTextApp());

class ParticleTextApp extends StatelessWidget {
  const ParticleTextApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const ParticleTextPage(),
    );
  }
}