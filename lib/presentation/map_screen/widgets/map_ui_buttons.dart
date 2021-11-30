import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/map_view_cubit.dart';
import 'package:variscite_mobile/presentation/user_screen/user_screen.dart';
import 'package:variscite_mobile/presentation/struct_import_screen/struct_import_screen.dart';

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

class UserSettingsButton extends StatelessWidget {
  const UserSettingsButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MapUiButton(
      Icons.account_circle_outlined,
      backgroundColor: theme.primaryColor,
      color: theme.iconTheme.color,
      onPressed: () => Navigator.pushNamed(context, UserScreen.route),
    );
  }
}

class StructAddButton extends StatelessWidget {
  const StructAddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MapUiButton(
      Icons.edit,
      backgroundColor: theme.primaryColor,
      color: theme.iconTheme.color,
      onPressed: () => Navigator.pushNamed(context, StructImportScreen.route),
    );
  }
}

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
