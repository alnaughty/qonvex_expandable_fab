import 'package:flutter/material.dart';

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    Key? key,
    this.onPressed,
    required this.message,
    required this.icon,
    required this.color,
  }) : super(key: key);

  final Function? onPressed;

  final Widget icon;
  final Color color;
  final String message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: color,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.accentIconTheme,
        child: IconButton(
          tooltip: message,
          onPressed: () {
            onPressed!();
          },
          icon: icon,
        ),
      ),
    );
  }
}
