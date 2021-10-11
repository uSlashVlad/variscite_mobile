import 'package:bloc/bloc.dart';

import 'package:variscite_mobile/utils/geometry/geometry_processing.dart';

class GeometryCubit extends Cubit<MapGeometryCollection> {
  GeometryCubit([MapGeometryCollection? initialCollection])
      : super(initialCollection ?? const MapGeometryCollection());

  void replaceGeometry(MapGeometryCollection newCollection) {
    emit(newCollection);
  }
}
