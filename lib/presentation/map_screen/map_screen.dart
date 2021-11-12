import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:variscite_mobile/bloc/api_cubit.dart';

import 'widgets/map_widget.dart';
import 'package:variscite_mobile/presentation/map_screen/bloc/geometry_cubit.dart';
import 'package:variscite_mobile/utils/consts.dart';

class MapScreen extends StatelessWidget {
  /// /map
  static String route = '/map';

  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GeometryCubit(),
      child: Scaffold(
        body: Stack(
          children: [
            Builder(builder: (context) {
              final apiC = context.read<ApiCubit>();
              final geometryC = context.read<GeometryCubit>();

              apiC.api.getAllStructures().then((value) {
                geometryC.loadStructuresToMap(value);
              });

              return const MapWidget();
            }),
            const Align(
              alignment: Alignment.bottomRight,
              child: Material(child: Text(tileProviderAttribution)),
            )
          ],
        ),
      ),
    );
  }
}
