import 'request.dart';

/// The `ApiRequest` class extends the `Request` class to add functionality for handling JWT payloads.
/// This class is used to wrap an `HttpRequest` and include the JWT payload in the request body.
class ApiRequest extends Request {
  /// The JWT payload extracted from the token.
  final Map<String, dynamic> jwtPayload;

  /// Creates an `ApiRequest` instance.
  ///
  /// [httpRequest]: The original `HttpRequest` object.
  /// [jwtPayload]: The payload of the JWT to be included in the request body.
  ApiRequest(super.httpRequest, this.jwtPayload);

  /// Reads and returns the body of the request as a string.
  ///
  /// This method overrides the `readAsString` method from the `Request` class.
  /// It reads the original body, adds the JWT payload to it, and returns the modified body as a JSON string.
  ///
  /// Returns a `Future<String>` that completes with the modified request body.
  @override
  Future<Map<String, dynamic>> read() async {
    final Map<String, dynamic> originalBody = await super.read();

    // Add the JWT payload to the original body
    originalBody['jwt_payload'] = jwtPayload;

    // Return the modified body as a JSON string
    return originalBody;
  }
}
