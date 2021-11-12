import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:variscite_dart/variscite_dart.dart';

abstract class ApiState {
  const ApiState();
}

class ApiInitialState extends ApiState {
  const ApiInitialState();
}

class ApiTokenLoading extends ApiState {
  const ApiTokenLoading();
}

class ApiTokenLoaded extends ApiState {
  const ApiTokenLoaded();
}

class ApiTokenNotLoaded extends ApiState {
  const ApiTokenNotLoaded();
}

class ApiCubit extends Cubit<ApiState> {
  ApiCubit([VarisciteApi? defaultHandler]) : super(const ApiInitialState()) {
    api = defaultHandler ?? VarisciteApi();
  }

  final _secureStorage = const FlutterSecureStorage();

  late final VarisciteApi api;

  Future<bool> loadTokenFromStorage() async {
    emit(const ApiTokenLoading());
    final token = await _secureStorage.read(key: 'userToken');
    if (token != null) {
      api.setToken(token);
      emit(const ApiTokenLoaded());
      return true;
    } else {
      emit(const ApiTokenNotLoaded());
      return false;
    }
  }

  Future<void> loadTokenToStorage(String token) async {
    await _secureStorage.write(key: 'userToken', value: token);
    emit(const ApiTokenLoaded());
  }
}
