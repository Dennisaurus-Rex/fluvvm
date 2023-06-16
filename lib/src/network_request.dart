import 'dart:convert';
import 'package:http/http.dart' as http;

/// This class is a wrapper around [http] and provides a simple
/// interface for making network requests.
///
/// Should be used inside your repository.

class NetworkRequest {
  /// Creates a new [NetworkRequest].
  ///
  /// `http://` scheme is __NOT__ supported and
  /// throws [NetworkRequestError.httpSchemeNotSupported]
  ///
  /// The Uri is constructed from [baseUrl], [path] and [query].
  /// `https://[baseUrl]/[path]?queryKey=queryValue&queryKey2=queryValue2`
  ///
  /// `Map<String, String> headers` and `Object body` are is passed
  /// when calling `fire()` on this [NetworkRequest].
  NetworkRequest({
    required String baseUrl,
    required this.path,
    this.method = NetworkMethod.get,
    this.query,
  }) {
    if (baseUrl.startsWith('http://')) {
      throw NetworkRequestError.httpSchemeNotSupported;
    }
    _baseUrl = baseUrl.replaceAll('https://', '');
  }

  /// The base URL of the request.
  String get baseUrl => _baseUrl;

  /// The path of the request.
  final String path;

  /// The HTTP method of the request.
  /// Defaults to [NetworkMethod.get].
  final NetworkMethod method;

  /// The query of the request.
  /// `https://example.com/api/v1/data?queryKey=queryValue&queryKey2=queryValue2`
  final Map<String, dynamic>? query;

  late String _baseUrl;
  Uri get _uri => Uri.https(_baseUrl, path, query);

  @override
  String toString() => _uri.toString();

  /// Fire the request.
  ///
  /// Returns a [Future] that completes with a [Map<String, Object?>]
  /// if the request is successful.
  ///
  /// Throws a [NetworkError] if the request fails.
  /// Rethrows any exception from [http].
  ///
  /// Throws [NetworkRequestError.bodyOnGetRequest] if
  /// [method] is [NetworkMethod.get] and [body] is not `null`.
  ///
  /// If you need to send headers with the request,
  /// pass them as [headers].
  ///
  /// If you need to send a body with the request, pass it as [body].
  /// The body will be encoded as JSON.
  Future<Map<String, Object?>> fire({
    Object? body,
    Map<String, String>? headers,
  }) async {
    if (body != null && method == NetworkMethod.get) {
      throw NetworkRequestError.bodyOnGetRequest;
    }

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

      if (code._isInRange(200, 299)) {
        final Map map = jsonDecode(response.body);
        final Map<String, Object?> json = Map.from(map);
        return json;
      } else {
        throw NetworkException.fromResponse(response);
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Fire the request.
  ///
  /// Returns a [Future] that completes with [T]
  /// if the request is successful.
  ///
  /// Hot Tip:
  /// [mapper] can be used with classes annotaded with
  /// [freezed](https://pub.dev/packages/freezed) or
  /// [json_serializable](https://pub.dev/packages/json_serializable)
  ///
  /// Throws a [NetworkError] if the request fails.
  /// Rethrows any exception from [http].
  ///
  /// Throws [NetworkRequestError.bodyOnGetRequest] if
  /// [method] is [NetworkMethod.get] and [body] is not `null`.
  ///
  /// If you need to send headers with the request,
  /// pass them as [headers].
  ///
  /// If you need to send a body with the request, pass it as [body].
  /// The body will be encoded as JSON.
  Future<T> fireAndMap<T>(
    /// Map the response to [T].
    T Function(Map<String, Object?>) mapper, {
    /// The body of the request.
    Object? body,

    /// The headers of the request.
    Map<String, String>? headers,
  }) async {
    try {
      final json = await fire(body: body, headers: headers);
      return mapper(json);
    } catch (e) {
      rethrow;
    }
  }
}

/// HTTP methods.
///
/// [get] = GET
/// [post] = POST
/// [put] = PUT
/// [delete] = DELETE
enum NetworkMethod { get, post, put, delete }

/// Response codes: 400 - 499 = [NetworkError.badRequest]
/// Response codes: 500 - 599 = [NetworkError.unauthorized]
/// Other response codes = [NetworkError.unkown]
enum NetworkError { badRequest, unauthorized, unkown }

/// Exception thrown when a network request fails.
class NetworkException implements Exception {
  const NetworkException(this.error, this.body, this.code);
  factory NetworkException.fromResponse(http.Response response) {
    final code = response.statusCode;
    if (code._isInRange(400, 499)) {
      return NetworkException(
        NetworkError.badRequest,
        response.body,
        code,
      );
    } else if (code._isInRange(500, 599)) {
      return NetworkException(
        NetworkError.unauthorized,
        response.body,
        code,
      );
    } else {
      return NetworkException(
        NetworkError.unkown,
        response.body,
        code,
      );
    }
  }

  /// The error that caused the exception.
  final NetworkError error;

  /// The response code.
  final int code;

  /// The response body.
  final String body;

  @override
  String toString() {
    return 'NetworkException: $error\nCode: $code\nBody: $body';
  }
}

/// Thrown when [NetworkRequest] usage is incorrect.
enum NetworkRequestError implements Exception {
  bodyOnGetRequest,
  httpSchemeNotSupported,
}

extension _IsInRange on int {
  bool _isInRange(int lower, int upper) => clamp(lower, upper) == this;
}
