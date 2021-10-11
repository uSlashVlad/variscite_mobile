import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';
import 'package:equatable/equatable.dart';

import 'package:variscite_mobile/presentation/common/marker_widget.dart';
import 'geometry_styles.dart';
import '../api.dart';

class MapGeometryCollection extends Equatable {
  const MapGeometryCollection({
    this.markers = const [],
    this.lines = const [],
    this.polygons = const [],
  });

  final List<Marker> markers;
  final List<Polyline> lines;
  final List<Polygon> polygons;

  MapGeometryCollection copyWith({
    List<Marker> markers = const [],
    List<Polyline> lines = const [],
    List<Polygon> polygons = const [],
  }) {
    markers.addAll(this.markers);
    lines.addAll(this.lines);
    polygons.addAll(this.polygons);

    return MapGeometryCollection(
      markers: markers,
      lines: lines,
      polygons: polygons,
    );
  }

  MapGeometryCollection mergeWith(MapGeometryCollection otherCollection) {
    return copyWith(
      markers: otherCollection.markers,
      lines: otherCollection.lines,
      polygons: otherCollection.polygons,
    );
  }

  @override
  String toString() {
    return '[MapGeometryCollection]\n'
        'markers: $markers\nlines: $lines\npolygons: $polygons';
  }

  @override
  List<Object?> get props => [markers, lines, polygons];
}

MapGeometryCollection createGeometryCollection(List<Structure> structs) {
  var result = const MapGeometryCollection();
  for (var struct in structs) {
    result = result.mergeWith(_translateGeoJSONtoLayers(struct.struct));
  }
  return result;
}

MapGeometryCollection _translateGeoJSONtoLayers(GeoJSON geo) {
  if (geo.type == GeoJSONType.featureCollection) {
    final collection = geo as GeoJSONFeatureCollection;
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
    return MapGeometryCollection(
      markers: markers,
      lines: lines,
      polygons: polygons,
    );
  } else if (geo.type == GeoJSONType.feature) {
    final structure = _convertFeature(geo as GeoJSONFeature);
    if (structure is Marker) {
      return MapGeometryCollection(markers: [structure]);
    } else if (structure is Polyline) {
      return MapGeometryCollection(lines: [structure]);
    } else if (structure is Polygon) {
      return MapGeometryCollection(polygons: [structure]);
    }
  }
  return const MapGeometryCollection();
}

dynamic _convertFeature(GeoJSONFeature feature) {
  switch (feature.geometry.type) {
    case GeoJSONType.point:
      final point = feature.geometry as GeoJSONPoint;
      final style = _parseMarkerStyle(feature.properties);
      return Marker(
        point: _convertLngLatList(point.coordinates),
        builder: (context) => MarkerWidget(style: style),
      );

    case GeoJSONType.lineString:
      final line = feature.geometry as GeoJSONLineString;
      final style = _parseLineStyle(feature.properties);
      final points = <LatLng>[];
      for (var coordinates in line.coordinates) {
        points.add(_convertLngLatList(coordinates));
      }
      // TODO use opacity property to polyline
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
        points.add(_convertLngLatList(coordinates));
      }
      final holePoints = <List<LatLng>>[];
      for (var i = 1; i < polygon.coordinates.length; i++) {
        final holes = <LatLng>[];
        for (var coordinates in polygon.coordinates[i]) {
          holes.add(_convertLngLatList(coordinates));
        }
        holePoints.add(holes);
      }
      return Polygon(
        points: points,
        holePointsList: holePoints,
        color: style.fillColor,
        borderColor: style.strokeColor,
        borderStrokeWidth: style.strokeWidth,
      );

    // TODO implement complicatedGeometries
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

MarkerStyle _parseMarkerStyle(Map<String, dynamic>? properties) {
  if (properties != null) {
    Color? color;
    if (properties.containsKey('marker-color')) {
      color = Color(_hexToIntColor(properties['marker-color']));
    }
    return MarkerStyle(color: color);
  } else {
    return MarkerStyle();
  }
}

LineStyle _parseLineStyle(Map<String, dynamic>? properties) {
  if (properties != null) {
    Color? color;
    if (properties.containsKey('stroke')) {
      color = Color(_hexToIntColor(properties['stroke']));
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
      width: _numOrNullToDouble(width, 4),
      opacity: _numOrNullToDouble(opacity, 1),
    );
  } else {
    return LineStyle();
  }
}

PolygonStyle _parsePolygonStyle(Map<String, dynamic>? properties) {
  if (properties != null) {
    Color? strokeColor;
    if (properties.containsKey('stroke')) {
      strokeColor = Color(_hexToIntColor(properties['stroke']));
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
      fill = Color(_hexToIntColor(properties['fill']));
    }
    num? fillOpacity;
    if (properties.containsKey('fill-opacity')) {
      fillOpacity = properties['fill-opacity'];
    }
    return PolygonStyle(
      strokeColor: strokeColor,
      strokeWidth: _numOrNullToDouble(width, 4),
      strokeOpacity: _numOrNullToDouble(strokeOpacity, 1),
      fillColor: fill,
      fillOpacity: _numOrNullToDouble(fillOpacity, 1),
    );
  } else {
    return PolygonStyle();
  }
}

double _numOrNullToDouble(num? number, double defaultValue) {
  if (number != null) {
    return number.toDouble();
  } else {
    return defaultValue;
  }
}

int _hexToIntColor(String colorString, [String opacity = 'ff']) =>
    int.parse(colorString.replaceFirst('#', '0x' + opacity));

LatLng _convertLngLatList(List<double> coordinates) =>
    LatLng(coordinates[1], coordinates[0]);
