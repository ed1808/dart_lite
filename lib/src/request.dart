import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

/// The `Request` class is a wrapper around `HttpRequest` to provide easier access to its properties and methods.
class Request {
  /// The underlying `HttpRequest` instance.
  final HttpRequest _httpRequest;

  /// A map representation of the request body, initialized as null.
  Map<String, dynamic>? _bodyMap;

  /// Creates a `Request` object from an `HttpRequest`.
  ///
  /// [httpRequest]: The `HttpRequest` object to wrap.
  Request(this._httpRequest);

  /// Gets the raw `HttpRequest` object.
  HttpRequest get raw => _httpRequest;

  /// Gets the URI of the request.
  Uri get uri => _httpRequest.uri;

  /// Gets the HTTP method (e.g., "GET", "POST") of the request.
  String get method => _httpRequest.method;

  /// Gets the headers of the request.
  HttpHeaders get headers => _httpRequest.headers;

  /// Gets the body of the request as a stream of byte arrays.
  Stream<Uint8List> get body => _httpRequest;

  /// Gets the body of the request as a map. If the body has not been read yet, it returns an empty map.
  Map<String, dynamic> get bodyMap => _bodyMap ?? {};

  /// Reads the body of the request and returns it as a `String`.
  ///
  /// This method decodes the body using UTF-8 encoding and also parses it as JSON, storing the result in `_bodyMap`.
  ///
  /// Returns a `Future<String>` that completes with the body of the request as a string.
  Future<Map<String, dynamic>> read() async {
    final String body = await utf8.decoder.bind(_httpRequest).join();
    Map<String, dynamic> decodedBody = jsonDecode(body);

    if (_bodyMap == null) {
      _bodyMap = decodedBody;
    } else {
      _bodyMap!.addEntries(decodedBody.entries);
    }

    return _bodyMap!;
  }

  /// Adds URL parameters to the request body.
  ///
  /// [params]: A map of parameter names and their values.
  ///
  /// This method adds the parameters to `_bodyMap` under the key 'req_params'.
  void addParamsToBody(Map<String, String> params) {
    _bodyMap ??= {};
    _bodyMap!['req_params'] = params;
  }
}
