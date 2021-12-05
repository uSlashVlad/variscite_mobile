import 'package:flutter/material.dart';

class MapUiButton extends StatelessWidget {
  const MapUiButton(
    this.icon, {
    Key? key,
    this.color,
    this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      child: Ink(
        width: 50,
        height: 50,
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: const CircleBorder(),
        ),
        child: IconButton(
          iconSize: 28,
          onPressed: onPressed,
          icon: Icon(icon),
          color: color,
        ),
      ),
    );
  }
}
