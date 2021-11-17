import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:variscite_dart/variscite_dart.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';

import 'geometry_styles.dart';
import 'marker_widget.dart';

class MapGeometry extends Equatable {
  const MapGeometry({
    this.markers = const [],
    this.lines = const [],
    this.polygons = const [],
  });

  final List<Marker> markers;
  final List<Polyline> lines;
  final List<Polygon> polygons;

  MapGeometry copyWith({
    List<Marker> markers = const [],
    List<Polyline> lines = const [],
    List<Polygon> polygons = const [],
  }) {
    return MapGeometry(
      markers: markers,
      lines: lines,
      polygons: polygons,
    );
  }

  MapGeometry mergeWith(MapGeometry otherCollection) {
    return copyWith(
      markers: [...markers, ...otherCollection.markers],
      lines: [...lines, ...otherCollection.lines],
      polygons: [...polygons, ...otherCollection.polygons],
    );
  }

  MapGeometry operator +(MapGeometry otherCollection) {
    return mergeWith(otherCollection);
  }

  static MapGeometry createFromStructures(List<GeoStruct> structs) {
    var result = const MapGeometry();
    for (var struct in structs) {
      result += _convertStructToMapGeometry(struct.struct);
    }
    return result;
  }

  static MapGeometry _convertStructToMapGeometry(
      GeoJSONFeatureCollection collection) {
    final markers = <Marker>[];
    final lines = <Polyline>[];
    final polygons = <Polygon>[];

    for (var feature in collection.features) {
      final structure = _convertFeature(feature!);
      if (structure is Marker) {
        markers.add(structure);
      } else if (structure is Polyline) {
        lines.add(structure);
      } else if (structure is Polygon) {
        polygons.add(structure);
      }
    }
    return MapGeometry(
      markers: markers,
      lines: lines,
      polygons: polygons,
    );
  }

  static dynamic _convertFeature(GeoJSONFeature feature) {
    switch (feature.geometry.type) {
      case GeoJSONType.point:
        final point = feature.geometry as GeoJSONPoint;
        final style = _parseMarkerStyle(feature.properties);
        return Marker(
          point: GeometryHelper.convertLngLatList(point.coordinates),
          builder: (context) => MarkerWidget(style: style),
        );

      case GeoJSONType.lineString:
        final line = feature.geometry as GeoJSONLineString;
        final style = _parseLineStyle(feature.properties);
        final points = <LatLng>[];
        for (var coordinates in line.coordinates) {
          points.add(GeometryHelper.convertLngLatList(coordinates));
        }
        // TODO use opacity property in polyline
        return Polyline(
          points: points,
          color: style.strokeColor,
          strokeWidth: style.strokeWidth,
        );

      case GeoJSONType.polygon:
        final polygon = feature.geometry as GeoJSONPolygon;
        final style = _parsePolygonStyle(feature.properties);
        final points = <LatLng>[];
        for (var coordinates in polygon.coordinates[0]) {
          points.add(GeometryHelper.convertLngLatList(coordinates));
        }
        final holePoints = <List<LatLng>>[];
        for (var i = 1; i < polygon.coordinates.length; i++) {
          final holes = <LatLng>[];
          for (var coordinates in polygon.coordinates[i]) {
            holes.add(GeometryHelper.convertLngLatList(coordinates));
          }
          holePoints.add(holes);
        }
        // TODO use opacity property in polygon
        return Polygon(
          points: points,
          holePointsList: holePoints,
          color: style.fillColor,
          borderColor: style.strokeColor,
          borderStrokeWidth: style.strokeWidth,
        );

      // TODO implement complex geometries
      // case GeoJSONType.multiPoint:
      //   break;
      // case GeoJSONType.multiLineString:
      //   break;
      // case GeoJSONType.multiPolygon:
      //   break;
      // case GeoJSONType.geometryCollection:
      //   break;

      default:
        return null;
    }
  }

  static MarkerStyle _parseMarkerStyle(Map<String, dynamic>? properties) {
    if (properties != null) {
      Color? color;
      Color? outlineColor;
      if (properties.containsKey('marker-color')) {
        color = Color(GeometryHelper.hexToIntColor(properties['marker-color']));
      }
      if (properties.containsKey('outline-color')) {
        outlineColor =
            Color(GeometryHelper.hexToIntColor(properties['outline-color']));
      }
      return MarkerStyle(color: color, outlineColor: outlineColor);
    } else {
      return MarkerStyle();
    }
  }

  static LineStyle _parseLineStyle(Map<String, dynamic>? properties) {
    if (properties != null) {
      Color? color;
      if (properties.containsKey('stroke')) {
        color = Color(GeometryHelper.hexToIntColor(properties['stroke']));
      }
      num? width;
      if (properties.containsKey('stroke-width')) {
        width = properties['stroke-width'];
      }
      num? opacity;
      if (properties.containsKey('stroke-opacity')) {
        opacity = properties['stroke-opacity'];
      }
      return LineStyle(
        color: color,
        width: GeometryHelper.numOrNullToDouble(width, 4),
        opacity: GeometryHelper.numOrNullToDouble(opacity, 1),
      );
    } else {
      return LineStyle();
    }
  }

  static PolygonStyle _parsePolygonStyle(Map<String, dynamic>? properties) {
    if (properties != null) {
      Color? strokeColor;
      if (properties.containsKey('stroke')) {
        strokeColor = Color(GeometryHelper.hexToIntColor(properties['stroke']));
      }
      num? width;
      if (properties.containsKey('stroke-width')) {
        width = properties['stroke-width'];
      }
      num? strokeOpacity;
      if (properties.containsKey('stroke-opacity')) {
        strokeOpacity = properties['stroke-opacity'];
      }
      Color? fill;
      if (properties.containsKey('fill')) {
        fill = Color(GeometryHelper.hexToIntColor(properties['fill']));
      }
      num? fillOpacity;
      if (properties.containsKey('fill-opacity')) {
        fillOpacity = properties['fill-opacity'];
      }
      return PolygonStyle(
        strokeColor: strokeColor,
        strokeWidth: GeometryHelper.numOrNullToDouble(width, 4),
        strokeOpacity: GeometryHelper.numOrNullToDouble(strokeOpacity, 1),
        fillColor: fill,
        fillOpacity: GeometryHelper.numOrNullToDouble(fillOpacity, 1),
      );
    } else {
      return PolygonStyle();
    }
  }

  @override
  String toString() {
    return '[MapGeometryCollection]\n'
        'markers: $markers\nlines: $lines\npolygons: $polygons';
  }

  @override
  List<Object?> get props => [markers, lines, polygons];
}

class LocationsCollection extends Equatable {
  const LocationsCollection({
    this.currentUserMarker,
    this.otherUsersMarkers = const [],
  });

  final Marker? currentUserMarker;
  final List<Marker> otherUsersMarkers;

  List<Marker> get locationMarkers {
    if (currentUserMarker == null) {
      return otherUsersMarkers;
    } else {
      return [...otherUsersMarkers, currentUserMarker!];
    }
  }

  LocationsCollection updateUserPosition(LatLng position) {
    return copyWith(
        currentUserMarker: Marker(
      point: position,
      builder: (context) => MarkerWidget(style: _currentUserMarkerStyle),
    ));
  }

  LocationsCollection updateOthersPosition(
      List<UserGeolocationOutput> geolocations) {
    return copyWith(
        otherUsersMarkers: geolocations
            .map((l) => Marker(
                  point: LatLng(l.position.latitude, l.position.longitude),
                  builder: (context) =>
                      MarkerWidget(style: _otherUsersMarkerStyle),
                ))
            .toList());
  }

  LocationsCollection copyWith({
    Marker? currentUserMarker,
    List<Marker>? otherUsersMarkers,
  }) {
    return LocationsCollection(
      currentUserMarker: currentUserMarker ?? this.currentUserMarker,
      otherUsersMarkers: otherUsersMarkers ?? this.otherUsersMarkers,
    );
  }

  static MarkerStyle get _currentUserMarkerStyle => MarkerStyle(
        color: Colors.white,
        outlineColor: Colors.blueAccent[400],
      );

  static MarkerStyle get _otherUsersMarkerStyle => MarkerStyle(
        color: Colors.grey[200],
        outlineColor: Colors.greenAccent[400],
      );

  // props method here generates list with latitude, longitude of each marker
  @override
  List<Object?> get props => [
        (currentUserMarker != null)
            ? [
                currentUserMarker!.point.latitude,
                currentUserMarker!.point.longitude
              ]
            : null,
        ...otherUsersMarkers
            .map((m) => [m.point.latitude, m.point.longitude])
            .toList(),
      ];
}

abstract class GeometryHelper {
  static double numOrNullToDouble(num? number, double defaultValue) {
    if (number != null) {
      return number.toDouble();
    } else {
      return defaultValue;
    }
  }

  static int hexToIntColor(String colorString, [String opacity = 'ff']) =>
      int.parse(colorString.replaceFirst('#', '0x' + opacity));

  static LatLng convertLngLatList(List<double> coordinates) =>
      LatLng(coordinates[1], coordinates[0]);
}
