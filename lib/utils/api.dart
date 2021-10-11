import 'dart:convert';

import 'package:geojson_vi/geojson_vi.dart';

import 'network.dart';
import 'consts.dart';
import 'errors.dart';

class ApiHandler {
  late final RequestsHandler _req;
  final JsonDecoder _json = const JsonDecoder();

  ApiHandler([String? token]) {
    if (token != null) {
      _req = RequestsHandler(apiUrl, {'Authorization': 'Bearer ' + token});
    } else {
      _req = RequestsHandler(apiUrl);
    }
  }

  Future<bool> isAvailable() async {
    final res = await _req.getRequest('/status');
    if (res.status == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<String> login(String inviteCode, String name,
      [String? passcode]) async {
    final res = await _req.postRequest(
        '/groups/$inviteCode',
        passcode == null
            ? {'name': name}
            : {'name': name, 'passcode': passcode});

    if (res.status == 200) {
      return _json.convert(res.data)['token'] as String;
    } else {
      throwErrorByStatusCode(res.status);
      return '';
    }
  }

  Future<List<Structure>> getAllStructures() async {
    final res = await _req.getRequest('/structures');

    if (res.status == 200) {
      final data = _json.convert(res.data) as List<dynamic>;
      final result = <Structure>[];
      for (var element in data) {
        result.add(Structure(
          id: element['id'],
          user: element['user'],
          struct: GeoJSON.fromMap(element['struct']),
        ));
      }
      return result;
    } else {
      throwErrorByStatusCode(res.status);
      return [];
    }
  }
}

class Structure {
  String id;
  String user;
  GeoJSON struct;

  Structure({required this.id, required this.user, required this.struct});
}
