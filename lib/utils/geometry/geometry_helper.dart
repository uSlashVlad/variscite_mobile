import 'package:latlong2/latlong.dart';

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
