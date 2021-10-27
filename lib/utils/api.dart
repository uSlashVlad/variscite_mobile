import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';

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

  Future<UserLoginResult?> login(String inviteCode, String name,
      [String? passcode]) async {
    final res = await _req.postRequest(
        '/groups/$inviteCode',
        passcode == null
            ? {'name': name}
            : {'name': name, 'passcode': passcode});

    if (res.status == 200) {
      final data = _json.convert(res.data);
      return UserLoginResult(userId: data['id'], token: data['token']);
    } else {
      throwErrorByStatusCode(res.status);
    }
  }

  Future<List<Structure>?> getAllStructures() async {
    final res = await _req.getRequest('/structures');

    if (res.status == 200) {
      final data = _json.convert(res.data) as List<dynamic>;
      final result = <Structure>[];
      for (var element in data) {
        result.add(Structure(
          id: element['id'],
          user: element['user'],
          struct: GeoJSON.fromMap(element['struct']),
          fields: element['fields'],
        ));
      }
      return result;
    } else {
      throwErrorByStatusCode(res.status);
    }
  }

  Future<Structure?> addNewStructure(GeoJSON struct) async {
    final res = await _req.postRequest('/structures', struct.toMap());

    if (res.status == 200) {
      final data = _json.convert(res.data);
      Structure result;
      result = Structure(
        id: data['id'],
        user: data['user'],
        struct: GeoJSON.fromMap(data['struct']),
        fields: data['fields'],
      );
      return result;
    } else {
      throwErrorByStatusCode(res.status);
    }
  }

  Future<List<UserGeolocation>?> getGeolocation() async {
    final res = await _req.getRequest('/location/all');

    if (res.status == 200) {
      final data = _json.convert(res.data) as List<dynamic>;
      final result = <UserGeolocation>[];

      for (var element in data) {
        result.add(UserGeolocation(
          userId: element['user'],
          position: LatLng(
            element['position']['latitude'],
            element['position']['longitude'],
          ),
        ));
      }

      return result;
    } else {
      throwErrorByStatusCode(res.status);
    }
  }

  Future<void> sendGeolocation(LatLng position) async {
    final res = await _req.putRequest('/location/my', {
      'latitude': position.latitude,
      'longitude': position.longitude,
    });

    if (res.status != 200) {
      throwErrorByStatusCode(res.status);
    }
  }
}

class UserLoginResult {
  final String userId;
  final String token;

  UserLoginResult({required this.userId, required this.token});
}

class Structure extends Equatable {
  final String id;
  final String user;
  final GeoJSON struct;
  final Map<String, dynamic> fields;

  const Structure({
    required this.id,
    required this.user,
    required this.struct,
    this.fields = const {},
  });

  @override
  List<Object?> get props => [id, user, struct, fields];
}

class UserGeolocation extends Equatable {
  final String userId;
  final LatLng position;

  const UserGeolocation({
    required this.userId,
    required this.position,
  });

  @override
  List<Object?> get props => [userId, position.latitude, position.longitude];
}
