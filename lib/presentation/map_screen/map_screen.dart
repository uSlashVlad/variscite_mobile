import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:variscite_dart/variscite_dart.dart';

import 'widgets/map_widget.dart';
import 'widgets/map_ui_buttons.dart';
import 'package:variscite_mobile/bloc/api_cubit.dart';
import '../../bloc/geometry_cubit.dart';
import 'bloc/locations_cubit.dart';
import 'bloc/map_view_cubit.dart';
import 'package:variscite_mobile/utils/consts.dart';
import 'package:variscite_mobile/utils/geolocation.dart';
import 'package:variscite_mobile/presentation/common/toasts.dart';

class MapScreen extends StatelessWidget {
  /// /main
  static String route = '/main';

  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) {
          final locationC = LocationCubit();
          final apiC = context.read<ApiCubit>();
          int i = 0;

          // FIXME here is temporary fix of leavig group, but timers and streams
          // should be closed gracefully
          Timer.periodic(const Duration(seconds: 2), (timer) {
            if (apiC.api.hasToken && apiC.state is! ApiTokenDeleted) {
              apiC.api
                  .getAllGeolocation(excludeUser: true)
                  .then((value) => locationC.updateOthersLocation(value));
            } else {
              showError('Token was deleted');
              timer.cancel();
            }
          });
          late final StreamSubscription streamSub;
          streamSub = getPositionStream().listen((pos) {
            if (apiC.api.hasToken && apiC.state is! ApiTokenDeleted) {
              if (i % 20 == 0) {
                apiC.api.editCurrentUserGeolocation(GeolocationPosition(
                  latitude: pos.latitude,
                  longitude: pos.longitude,
                ));
              }
              locationC.updateUserLocation(LatLng(pos.latitude, pos.longitude));
              i++;
            } else {
              showError('Token was deleted');
              streamSub.cancel();
            }
          });
          return locationC;
        }),
        BlocProvider(create: (context) => MapViewCubit()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Builder(builder: (context) {
              final apiC = context.read<ApiCubit>();

              try {
                apiC.api.getAllStructures().then((value) =>
                    context.read<GeometryCubit>().loadStructuresToMap(value));

                apiC.api.getAllGeolocation(excludeUser: true).then((value) =>
                    context.read<LocationCubit>().updateOthersLocation(value));
              } catch (e) {
                showError('Error while map update');
              }

              return MapWidget();
            }),
            const Align(
              alignment: Alignment.bottomRight,
              child: Text(tileProviderAttribution),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocBuilder<MapViewCubit, MapViewState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        LocatorButton(value: state.isViewLocked),
                        if (!state.isViewLocked && !state.isLocationZero)
                          const SizedBox(height: 5),
                        ResetRotationButton(value: state.isLocationZero),
                        const SizedBox(height: 5),
                        const UserSettingsButton(),
                        const SizedBox(height: 5),
                        const StructAddButton(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
