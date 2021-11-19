import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:variscite_dart/variscite_dart.dart';

import '../../presentation/common/marker_widget.dart';
import 'geometry_styles.dart';

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
