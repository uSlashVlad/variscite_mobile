import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:variscite_mobile/utils/api.dart';

abstract class ApiState {}

class ApiLoadingState extends ApiState {}

class ApiTokensLoaded extends ApiState {
  ApiTokensLoaded(this.loadedCount);

  final int loadedCount;
}

class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiLoadingState());

  final groupsApi = <ApiHandler>[];

  final _secureStorage = const FlutterSecureStorage();
  Box<String>? _tokensBox;

  Future<void> loadApis() async {
    _tokensBox ??= await _initTokenBox();

    final tokenCount = _tokensBox!.length;
    for (var i = 0; i < tokenCount; i++) {
      final token = _tokensBox!.getAt(i)!;
      groupsApi.add(ApiHandler(token));
    }

    await _tokensBox!.close();
    _tokensBox = null;

    emit(ApiTokensLoaded(tokenCount));
  }

  Future<void> addApiToken(String token) async {
    _tokensBox ??= await _initTokenBox();

    _tokensBox!.add(token);
    groupsApi.add(ApiHandler(token));

    await _tokensBox!.close();
    _tokensBox = null;

    emit(ApiTokensLoaded(1));
  }

  Future<Box<String>> _initTokenBox() async {
    // Getting encryption key
    late final List<int> secureKey;
    if (await isFirstOpen()) {
      secureKey = Hive.generateSecureKey();
      await _secureStorage.write(
          key: 'secureKey', value: base64UrlEncode(secureKey));
    } else {
      secureKey = base64Decode((await _secureStorage.read(key: 'secureKey'))!);
    }

    // Openning or creating encrypted box
    return Hive.openBox('tokens', encryptionCipher: HiveAesCipher(secureKey));
  }

  Future<bool> isFirstOpen() async =>
      !(await _secureStorage.containsKey(key: 'secureKey'));
}
