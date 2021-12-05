import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/map_view_cubit.dart';
import 'package:variscite_mobile/presentation/user_screen/user_screen.dart';
import 'package:variscite_mobile/presentation/struct_import_screen/struct_import_screen.dart';
import 'map_ui_button_base.dart';

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
