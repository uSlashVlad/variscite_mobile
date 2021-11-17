import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/map_view_cubit.dart';

class LocatorButton extends StatelessWidget {
  const LocatorButton({
    Key? key,
    required this.value,
  }) : super(key: key);

  final bool value;

  @override
  Widget build(BuildContext context) {
    return !value
        ? MapUiButton(
            Icons.location_searching,
            backgroundColor: Colors.lightBlue,
            onPressed: () => context.read<MapViewCubit>().lockView(),
          )
        : const SizedBox();
  }
}

class ResetRotationButton extends StatelessWidget {
  const ResetRotationButton({
    Key? key,
    required this.value,
  }) : super(key: key);

  final bool value;

  @override
  Widget build(BuildContext context) {
    return !value
        ? MapUiButton(
            Icons.compass_calibration,
            backgroundColor: Colors.lightBlue,
            onPressed: () => context.read<MapViewCubit>().resetRotation(),
          )
        : const SizedBox();
  }
}

class MapUiButton extends StatelessWidget {
  const MapUiButton(
    this.icon, {
    Key? key,
    this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
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
        ),
      ),
    );
  }
}
