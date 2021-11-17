import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class MapViewState extends Equatable {
  const MapViewState({this.isViewLocked = false, this.isLocationZero = true});

  final bool isViewLocked;
  final bool isLocationZero;

  @override
  List<Object?> get props => [isViewLocked, isLocationZero];
}

// class DefaultMapViewState extends MapViewState {
//   const DefaultMapViewState(
//       {bool isViewLocked = false, bool isLocationZero = true})
//       : super(
//           isViewLocked: isViewLocked,
//           isLocationZero: isLocationZero,
//         );
// }

class MapViewCubit extends Cubit<MapViewState> {
  MapViewCubit() : super(const MapViewState());

  void lockView() => emit(MapViewState(
        isViewLocked: true,
        isLocationZero: state.isLocationZero,
      ));

  void unlockView() => emit(MapViewState(
        isViewLocked: false,
        isLocationZero: state.isLocationZero,
      ));

  void resetRotation() => emit(MapViewState(
        isViewLocked: state.isViewLocked,
        isLocationZero: true,
      ));

  void rotationChanged() => emit(MapViewState(
        isViewLocked: state.isViewLocked,
        isLocationZero: false,
      ));
}
