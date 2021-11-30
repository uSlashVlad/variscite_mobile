import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'cached_tiles.dart';
import '../../../bloc/geometry_cubit.dart';
import '../bloc/locations_cubit.dart';
import '../bloc/map_view_cubit.dart';
import 'package:variscite_mobile/utils/geometry/map_geometry.dart';
import 'package:variscite_mobile/utils/geometry/locations_collection.dart';
import 'package:variscite_mobile/utils/consts.dart';

class MapWidget extends StatelessWidget {
  MapWidget({Key? key}) : super(key: key);

  final GlobalKey _mapKey = GlobalKey();
  final _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryCubit, MapGeometry>(
      builder: (context, geometryState) {
        return BlocConsumer<MapViewCubit, MapViewState>(
          listener: (context, mapViewState) async {
            await _mapController.onReady;
            if (mapViewState.isLocationZero) {
              _mapController.rotate(0);
            }
          },
          builder: (context, mapViewState) {
            return BlocBuilder<LocationCubit, LocationsCollection>(
              builder: (context, locationState) {
                _mapController.onReady.then((_) {
                  if (mapViewState.isViewLocked &&
                      locationState.currentUserMarker != null) {
                    _mapController.move(locationState.currentUserMarker!.point,
                        _mapController.zoom);
                  }
                });

                return FlutterMap(
                  key: _mapKey,
                  mapController: _mapController,
                  options: MapOptions(
                    center: LatLng(55.6701, 37.4801),
                    zoom: 15,
                    minZoom: 2,
                    maxZoom: 18,
                    onTap: (position, latLng) {
                      print(latLng);
                    },
                    onPositionChanged: (position, hasGesture) {
                      final mapViewC = context.read<MapViewCubit>();
                      if (hasGesture) {
                        if (mapViewState.isViewLocked) {
                          mapViewC.unlockView();
                        }
                        if (mapViewState.isLocationZero &&
                            _mapController.rotation != 0) {
                          mapViewC.rotationChanged();
                        }
                      }
                    },
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: tileProviderUrl,
                      subdomains: tileProviderSubdomains,
                      tileProvider: const CachedTileProvider(),
                    ),
                    PolygonLayerOptions(
                      polygons: geometryState.polygons,
                    ),
                    PolylineLayerOptions(
                      polylines: geometryState.lines,
                    ),
                    MarkerLayerOptions(
                      markers: geometryState.markers,
                    ),
                    MarkerLayerOptions(
                      markers: locationState.locationMarkers,
                    )
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
