import 'package:fluvvm/fluvvm.dart';

class MyRepository {
  String baseUrl = 'https://example.com';
  String path = '/api/v1/data';

  late NetworkRequest fetchRequest = NetworkRequest(
    baseUrl: baseUrl,
    path: path,
    query: {'id': '1'},
  );

  Future<Map<String, dynamic>> store(Object data) async {
    try {
      final request = NetworkRequest(
        baseUrl: baseUrl,
        path: path,
        method: NetworkMethod.post,
      );
      return await request.fire(body: data);
    } catch (e) {
      rethrow;
    }
  }
}
