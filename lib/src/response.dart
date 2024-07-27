import 'dart:convert';
import 'dart:io';

/// The `Response` class is a wrapper around `HttpResponse` to provide easier ways to handle responses.
class Response {
  /// The underlying `HttpResponse` instance.
  final HttpResponse _httpResponse;

  /// Creates a `Response` object from an `HttpResponse`.
  ///
  /// [httpResponse]: The `HttpResponse` object to wrap.
  Response(this._httpResponse);

  /// Gets the raw `HttpResponse` object.
  HttpResponse get raw => _httpResponse;

  /// Gets the headers of the response.
  HttpHeaders get headers => _httpResponse.headers;

  /// Gets the status code of the response.
  int get statusCode => _httpResponse.statusCode;

  /// Sets the status code for the response.
  ///
  /// [statusCode]: The status code to set. Defaults to 200 if not provided.
  void status([int statusCode = 200]) {
    _httpResponse.statusCode = statusCode;
  }

  /// Sends a plain text response.
  ///
  /// [data]: The string data to send in the response body.
  /// [contentType]: The content type of the response. Defaults to `ContentType.html` if not provided.
  void send(String data, [ContentType? contentType]) {
    _httpResponse
      ..headers.contentType = contentType ?? ContentType.html
      ..write(data)
      ..close();
  }

  /// Sends a JSON response.
  ///
  /// [data]: The JSON data to send in the response body.
  /// The content type is automatically set to `ContentType.json`.
  void json(Map<String, dynamic> data) {
    try {
      _httpResponse
        ..headers.contentType = ContentType.json
        ..write(jsonEncode(data))
        ..close();
    } catch (err) {
      _httpResponse
        ..headers.contentType = ContentType.json
        ..statusCode = HttpStatus.internalServerError
        ..write(jsonEncode({"error": err}))
        ..close();
    }
  }
}
