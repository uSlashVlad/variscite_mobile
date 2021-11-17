import 'package:bloc/bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:variscite_dart/variscite_dart.dart';

import 'package:variscite_mobile/utils/geometry/map_geometry.dart';

class LocationCubit extends Cubit<LocationsCollection> {
  LocationCubit([LocationsCollection? defaultLocations])
      : super(defaultLocations ?? const LocationsCollection());

  void updateUserLocation(LatLng position) {
    emit(state.updateUserPosition(position));
  }

  void updateOthersLocation(List<UserGeolocationOutput> geolocations) {
    emit(state.updateOthersPosition(geolocations));
  }
}
