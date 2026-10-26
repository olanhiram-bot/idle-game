import 'package:flutter/material.dart'
    hide FilledButton, OutlinedButton, TextButton, SwitchListTile;

import 'game_theme.dart';

import 'package:flutter/services.dart';

/// Game-drawn controls: no Material button, switch or ripple underneath.
class FilledButton extends StatefulWidget {
  const FilledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
    this.secondary = false,
    this.tertiary = false,
  });
  FilledButton.icon({
    super.key,
    required this.onPressed,
    required Widget icon,
    required Widget label,
    this.style,
    this.secondary = false,
    this.tertiary = false,
  }) : child = Wrap(
         alignment: WrapAlignment.center,
         crossAxisAlignment: WrapCrossAlignment.center,
         spacing: 8,
         children: [icon, label],
       );
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;
  final bool secondary;
  final bool tertiary;
  @override
  State<FilledButton> createState() => _GameButtonState();
}

class _GameButtonState extends State<FilledButton> {
  bool pressed = false;
  bool focused = false;
  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null;
    final states = <WidgetState>{if (!enabled) WidgetState.disabled};
    final border =
        widget.style?.side?.resolve(states)?.color ??
        (widget.secondary ? GameStyle.teal : const Color(0xFFFFE6AA));
    final fill = widget.style?.backgroundColor?.resolve(states);
    return Semantics(
      button: true,
      enabled: enabled,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onShowFocusHighlight: (v) => setState(() => focused = v),
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onPressed?.call();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          onTapDown: enabled ? (_) => setState(() => pressed = true) : null,
          onTapCancel: () => setState(() => pressed = false),
          onTapUp: (_) => setState(() => pressed = false),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: EdgeInsets.only(bottom: widget.tertiary ? 0 : 3),
            decoration: BoxDecoration(
              color: widget.tertiary
                  ? Colors.transparent
                  : enabled
                  ? const Color(0xFF07111F)
                  : const Color(0xFF1C2939),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Transform.translate(
              offset: Offset(0, pressed ? 3 : 0),
              child: Container(
                constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: focused
                        ? Colors.white
                        : widget.tertiary
                        ? Colors.transparent
                        : enabled
                        ? border
                        : GameStyle.edge,
                    width: 2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: widget.tertiary
                        ? [Colors.transparent, Colors.transparent]
                        : !enabled
                        ? [const Color(0xFF334158), const Color(0xFF283347)]
                        : widget.secondary
                        ? [
                            fill ?? const Color(0xFF365674),
                            const Color(0xFF1B304D),
                          ]
                        : [const Color(0xFFFFDB89), const Color(0xFFE89A42)],
                  ),
                ),
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: enabled
                        ? widget.secondary
                              ? Colors.white
                              : const Color(0xFF302316)
                        : GameStyle.muted,
                    fontSize: 14,
                    fontWeight: widget.tertiary
                        ? FontWeight.w600
                        : FontWeight.w800,
                    letterSpacing: .2,
                  ),
                  textAlign: TextAlign.center,
                  child: IconTheme(
                    data: IconThemeData(
                      color: widget.secondary
                          ? GameStyle.teal
                          : const Color(0xFF48301A),
                      size: 22,
                    ),
                    child: Center(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class OutlinedButton extends FilledButton {
  const OutlinedButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.style,
  }) : super(secondary: true);
  OutlinedButton.icon({
    super.key,
    required super.onPressed,
    required super.icon,
    required super.label,
    super.style,
  }) : super.icon(secondary: true);
  static ButtonStyle styleFrom({BorderSide? side, Color? backgroundColor}) =>
      ButtonStyle(
        side: WidgetStatePropertyAll(side),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      );
}

class TextButton extends FilledButton {
  const TextButton({super.key, required super.onPressed, required super.child})
    : super(secondary: true, tertiary: true);
  TextButton.icon({
    super.key,
    required super.onPressed,
    required super.icon,
    required super.label,
  }) : super.icon(secondary: true, tertiary: true);
}

class SwitchListTile extends StatelessWidget {
  const SwitchListTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.secondary,
  });
  final Widget title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? secondary;
  @override
  Widget build(BuildContext context) => Semantics(
    toggled: value,
    child: OutlinedButton(
      onPressed: () => onChanged(!value),
      child: Row(
        children: [
          if (secondary != null) ...[secondary!, const SizedBox(width: 12)],
          Expanded(child: title),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: value ? const Color(0xFF276757) : GameStyle.ink,
              border: Border.all(
                color: value ? GameStyle.teal : GameStyle.edge,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(value ? 'SÍ' : 'NO'),
          ),
        ],
      ),
    ),
  );
}
