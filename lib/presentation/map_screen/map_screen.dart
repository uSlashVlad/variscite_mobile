import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:variscite_mobile/bloc/api_cubit.dart';
import 'package:latlong2/latlong.dart';

import 'widgets/map_widget.dart';
import 'package:variscite_mobile/presentation/map_screen/bloc/geometry_cubit.dart';
import 'package:variscite_mobile/presentation/map_screen/bloc/locations_cubit.dart';
import 'package:variscite_mobile/utils/consts.dart';
import 'package:variscite_mobile/utils/geolocation.dart';

class MapScreen extends StatelessWidget {
  /// /map
  static String route = '/map';

  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => GeometryCubit()),
        BlocProvider(create: (context) {
          final locationC = LocationCubit();
          positionStream.listen((pos) {
            locationC.updateUserLocation(LatLng(pos.latitude, pos.longitude));
          });
          return locationC;
        }),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Builder(builder: (context) {
              final apiC = context.read<ApiCubit>();
              final geometryC = context.read<GeometryCubit>();
              final locationC = context.read<LocationCubit>();

              apiC.api
                  .getAllStructures()
                  .then((value) => geometryC.loadStructuresToMap(value));

              apiC.api
                  .getAllGeolocation()
                  .then((value) => locationC.updateOthersLocation(value));

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
