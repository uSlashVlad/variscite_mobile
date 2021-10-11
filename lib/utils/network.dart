import 'package:dio/dio.dart';

class RequestsHandler {
  late final Dio _dio;

  RequestsHandler(String baseUrl, [Map<String, dynamic>? headers]) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      headers: headers,
      responseType: ResponseType.plain,
    ));
  }

  Future<Res> getRequest(String path) async {
    final res = await _dio.get(path);
    return Res(res.statusCode ?? 0, res.data);
  }

  Future<Res> postRequest(String path, dynamic body) async {
    final res = await _dio.post(path, data: body);
    return Res(res.statusCode ?? 0, res.data);
  }

  Future<Res> putRequest(String path, dynamic body) async {
    final res = await _dio.put(path, data: body);
    return Res(res.statusCode ?? 0, res.data);
  }

  Future<Res> deleteRequest(String path) async {
    final res = await _dio.delete(path);
    return Res(res.statusCode ?? 0, res.data);
  }
}

class Res {
  final int status;
  final dynamic data;

  Res(this.status, this.data);
}
