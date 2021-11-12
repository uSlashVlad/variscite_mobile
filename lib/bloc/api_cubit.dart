import 'package:bloc/bloc.dart';
import 'package:variscite_dart/variscite_dart.dart';

abstract class ApiState {
  const ApiState();
}

class ApiInitialState extends ApiState {
  const ApiInitialState();
}

class ApiCubit extends Cubit<ApiState> {
  ApiCubit([VarisciteApi? defaultHandler]) : super(const ApiInitialState()) {
    api = defaultHandler ?? VarisciteApi();
  }

  late final VarisciteApi api;
}
