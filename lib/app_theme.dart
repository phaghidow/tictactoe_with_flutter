import 'package:flutter/material.dart';

abstract final class GameColors {
  static const background = Color(0xFFF7F5FF);
  static const surface = Color(0xFFFFFEFF);
  static const ink = Color(0xFF28253D);
  static const muted = Color(0xFF88859C);
  static const violet = Color(0xFF7464E8);
  static const violetDark = Color(0xFF5C4ACF);
  static const mint = Color(0xFF39BFA2);
  static const coral = Color(0xFFFF8968);
  static const yellow = Color(0xFFFFCA62);
}

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: GameColors.violet,
      brightness: Brightness.light,
    ).copyWith(
      primary: GameColors.violet,
      secondary: GameColors.mint,
      surface: GameColors.surface,
      onSurface: GameColors.ink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: GameColors.background,
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: GameColors.ink,
        elevation: 0,
        centerTitle: false,
      ),
      textTheme: ThemeData.light().textTheme.apply(
        bodyColor: GameColors.ink,
        displayColor: GameColors.ink,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: GameColors.violet,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}

class GameBackground extends StatelessWidget {
  const GameBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [GameColors.background, Color(0xFFFFF8F1)],
            ),
          ),
        ),
        const Positioned(
          top: -76,
          right: -52,
          child: _ColorBubble(color: Color(0x337464E8), size: 190),
        ),
        const Positioned(
          bottom: -96,
          left: -60,
          child: _ColorBubble(color: Color(0x33FFCA62), size: 210),
        ),
        child,
      ],
    );
  }
}

class _ColorBubble extends StatelessWidget {
  const _ColorBubble({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
