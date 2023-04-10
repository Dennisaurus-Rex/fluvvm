import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkRequest {
  NetworkRequest({
    required this.baseUrl,
    required this.path,
    this.method = NetworkMethod.get,
    this.query,
    this.headers,
  });

  final String baseUrl;
  final String path;
  final NetworkMethod method;
  final Map<String, dynamic>? query;
  final Map<String, String>? headers;

  Uri get _uri => Uri.https(baseUrl, path, query);

  Future<Map<String, Object?>> fire({
    Object? body,
  }) async {
    final jsonBody = jsonEncode(body);

    try {
      http.Response response;
      switch (method) {
        case NetworkMethod.get:
          response = await http.get(
            _uri,
            headers: headers,
          );
          break;
        case NetworkMethod.post:
          response = await http.post(
            _uri,
            body: jsonBody,
            headers: headers,
          );
          break;
        case NetworkMethod.put:
          response = await http.put(
            _uri,
            body: jsonBody,
            headers: headers,
          );
          break;
        case NetworkMethod.delete:
          response = await http.delete(
            _uri,
            body: jsonBody,
            headers: headers,
          );
          break;
      }

      final code = response.statusCode;

      if (code.isInRange(200, 299)) {
        final Map map = jsonDecode(response.body);
        final Map<String, Object?> json = Map.from(map);
        return json;
      } else if (code.isInRange(400, 499)) {
        throw NetworkError.badRequest;
      } else if (code.isInRange(500, 599)) {
        throw NetworkError.unauthorized;
      } else {
        throw NetworkError.unkown;
      }
    } catch (e) {
      rethrow;
    }
  }
}

enum NetworkMethod { get, post, put, delete }

enum NetworkError implements Exception { badRequest, unauthorized, unkown }

extension IsInRange on int {
  bool isInRange(int lower, int upper) => clamp(lower, upper) == this;
}
