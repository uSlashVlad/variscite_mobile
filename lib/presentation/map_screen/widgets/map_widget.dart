import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'cached_tiles.dart';
import 'package:variscite_mobile/presentation/map_screen/bloc/geometry_cubit.dart';
import 'package:variscite_mobile/presentation/map_screen/bloc/locations_cubit.dart';
import 'package:variscite_mobile/utils/geometry/map_geometry.dart';
import 'package:variscite_mobile/utils/consts.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryCubit, MapGeometry>(
      builder: (context, geometryState) {
        return BlocBuilder<LocationCubit, LocationsCollection>(
          builder: (context, locationState) {
            return FlutterMap(
              options: MapOptions(
                center: LatLng(55.6701, 37.4801),
                zoom: 15,
                minZoom: 2,
                maxZoom: 18,
                onTap: (position, latLng) {
                  print(latLng);
                },
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: tileProviderUrl,
                  subdomains: tileProviderSubdomains,
                  tileProvider: const CachedTileProvider(),
                  // attributionBuilder: (_) {
                  //   return const Material(child: );
                  // },
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
  }
}
