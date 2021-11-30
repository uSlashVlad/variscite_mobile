import 'package:bloc/bloc.dart';
import 'package:variscite_dart/variscite_dart.dart';

import 'package:variscite_mobile/utils/geometry/map_geometry.dart';

class GeometryCubit extends Cubit<MapGeometry> {
  GeometryCubit([MapGeometry? defaultGeometry])
      : super(defaultGeometry ?? const MapGeometry());

  void loadStructuresToMap(List<GeoStruct> structs) {
    emit(MapGeometry.createFromStructures(structs));
  }

  void addStructure(GeoStruct struct) {
    final newGeometry = MapGeometry.createFromStructures([struct]);
    emit(state.mergeWith(newGeometry));
  }
}
