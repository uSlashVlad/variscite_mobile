import 'package:bloc/bloc.dart';

class AdminCheckBoxCubit extends Cubit<bool> {
  AdminCheckBoxCubit() : super(false);

  void changeValue(bool? newValue) {
    if (newValue != null) {
      emit(newValue);
    } else {
      emit(!state);
    }
  }
}
