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

/// Simple get with map request.
Future<MyResponseModel> getWithMap(String id) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      query: {'id': id},
    );
    return await request.fireAndMap(MyResponseModel.fromJson);
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

/// Simple post with map request.
Future<MyResponseModel> postWithMap(Object data) async {
  try {
    final request = NetworkRequest(
      baseUrl: 'https://example.com',
      path: '/api/v1/data',
      method: NetworkMethod.post,
    );
    return await request.fireAndMap(MyResponseModel.fromJson, body: data);
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

/// Example response model used to demonstrate fire and map requests.
class MyResponseModel {
  MyResponseModel({
    required this.id,
    required this.name,
  });

  factory MyResponseModel.fromJson(Map<String, dynamic> json) {
    return MyResponseModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  final String id;
  final String name;
}
