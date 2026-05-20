# particles_text

Interactive Flutter demo: text is rasterized to pixels, sampled into particles, then animated letter-by-letter into place. Hover or drag to scatter them; they spring back.

## Pipeline

<p align="center">
  <img src="/flowchart.png" alt="Pipeline flowchart" width="100%" />
</p>

1. **TextRasterizer** — draws the string to an offscreen buffer, samples opaque pixels on a grid, assigns each dot a rest position and a random scattered start.
2. **LetterRevealer** — enables particles one letter at a time (left to right).
3. **ParticlePhysics** — integrates velocity, applies pointer repulsion, damping, and spring-back each frame.
4. **ParticlePainter** — draws revealed dots on the canvas.

## Run

```bash
flutter run -d chrome   # or macos / ios / android
```

## Formulas

| Step | Formula |
|------|---------|
| Text vertical center | `dy = (canvasHeight − paragraphHeight) / 2` |
| Text horizontal center | `dx = (canvasWidth − textWidth) / 2` |
| Scatter start | `x₀ = px + U(−½, ½) · canvasWidth · scatter`<br>`y₀ = py + U(−½, ½) · canvasHeight · scatter` |
| Distance to pointer | `d = √(dx² + dy²)` where `dx = x − pointerX`, `dy = y − pointerY` |
| Hover impulse (linear falloff) | `strength = (1 − d / radius) · force` (zero if `d ≥ radius`) |
| Impulse direction | `(nx, ny) = (dx / d, dy / d)` |
| Velocity update | `vx += nx · strength`, `vy += ny · strength` |
| Position integration | `x += vx`, `y += vy` |
| Damping | `vx *= damping`, `vy *= damping` |
| Spring to rest | `x += (restX − x) · assembleSpeed`, same for `y` |
| Fade-in | `opacity = min(1, opacity + fadeInStep)` |

Default tunables live in `ParticleSettingsNotifier` (`config.dart`).
