import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:variscite_mobile/utils/consts.dart';
import 'cached_tiles.dart';
import 'package:variscite_mobile/utils/geometry/geometry_processing.dart';
import 'package:variscite_mobile/bloc/map_screen/geometry_cubit.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeometryCubit, MapGeometryCollection>(
        builder: (context, state) {
      return FlutterMap(
        options: MapOptions(
          center: LatLng(55.6701, 37.4801),
          zoom: 15,
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
            //   return const Material(child: Text(tileProviderAttribution));
            // },
          ),
          PolygonLayerOptions(
            polygons: state.polygons,
          ),
          PolylineLayerOptions(
            polylines: state.lines,
          ),
          MarkerLayerOptions(
            markers: state.markers,
          ),
        ],
      );
    });
  }
}
