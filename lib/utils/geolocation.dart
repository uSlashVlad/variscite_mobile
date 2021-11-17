import 'package:geolocator/geolocator.dart';

Future<bool> requestPermissions() async {
  final serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
  }

  return true;
}

Stream<Position> get positionStream =>
    Geolocator.getPositionStream();
