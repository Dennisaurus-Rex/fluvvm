import 'package:fluvvm/fluvvm.dart';

/// Simple get request.
Future<Map<String, dynamic>> get(
  String id,
  Map<String, String>? headers,
) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      query: {'id': id},
    );
    return await request.fire(headers: headers);
  } catch (e) {
    rethrow;
  }
}

/// Simple post request.
Future<Map<String, dynamic>> post(Object data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.post,
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}

/// Simple put request.
Future<Map<String, dynamic>> put(Object data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.put,
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}

/// Simple delete request.
Future<Map<String, dynamic>> delete(String id, Object? data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.delete,
      query: {'id': id},
    );
    return await request.fire(body: data);
  } catch (e) {
    rethrow;
  }
}
