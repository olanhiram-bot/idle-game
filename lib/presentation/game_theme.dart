import 'package:flutter/material.dart';

abstract final class GameStyle {
  static const ink = Color(0xFF091B28);
  static const panel = Color(0xFF252F50);
  static const edge = Color(0xFF56678D);
  static const gold = Color(0xFFFFBE62);
  static const teal = Color(0xFF88E6E1);
  static const muted = Color(0xFFB2C8D2);

  static ThemeData theme() => ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: gold,
      secondary: teal,
      surface: panel,
      onSurface: Color(0xFFF0F4F0),
      onPrimary: ink,
      outline: edge,
    ),
    scaffoldBackgroundColor: ink,
    appBarTheme: const AppBarTheme(
      backgroundColor: panel,
      foregroundColor: Colors.white,
      centerTitle: false,
      elevation: 0,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: panel,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: edge, width: 2),
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: teal,
      linearTrackColor: ink,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? gold : muted,
      ),
      trackColor: WidgetStateProperty.resolveWith(
        (s) => s.contains(WidgetState.selected) ? const Color(0xFF496786) : ink,
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        height: 1.05,
        letterSpacing: -1,
      ),
      titleLarge: TextStyle(
        fontSize: 23,
        fontWeight: FontWeight.w800,
        height: 1.15,
      ),
      titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
      bodyMedium: TextStyle(fontSize: 13, height: 1.4),
      bodySmall: TextStyle(fontSize: 12, height: 1.35, color: muted),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size(48, 54),
        elevation: 5,
        shadowColor: Colors.black54,
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(48, 52),
        foregroundColor: teal,
        side: const BorderSide(color: edge),
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(48, 48),
        foregroundColor: muted,
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: ink,
      showDragHandle: true,
      dragHandleColor: edge,
    ),
    dividerTheme: const DividerThemeData(color: edge),
  );
}

class GamePanel extends StatelessWidget {
  const GamePanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.accent = GameStyle.edge,
  });
  final Widget child;
  final EdgeInsets padding;
  final Color accent;
  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF303E60), Color(0xFF192A43)],
      ),
      border: Border.all(color: accent, width: 1.5),
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x40000000),
          offset: Offset(0, 5),
          blurRadius: 12,
        ),
      ],
    ),
    child: child,
  );
}

class SectionHeading extends StatelessWidget {
  const SectionHeading(this.title, this.subtitle, {super.key});
  final String title, subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
      ],
    ),
  );
}
