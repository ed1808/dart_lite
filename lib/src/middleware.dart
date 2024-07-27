import 'request.dart';
import 'response.dart';

/// A `Middleware` is a function that can perform actions before or after a request is handled by a `Handler`.
///
/// [request]: The `Request` object representing the incoming HTTP request.
/// [response]: The `Response` object used to send a response back to the client.
/// [next]: A callback function that, when called, passes control to the next middleware or handler in the stack.
typedef Middleware = void Function(
    Request request, Response response, void Function(Request req, Response res) next);

/// The `MiddlewareFactory` abstract class defines a contract for creating middleware instances.
///
/// Classes that implement this abstract class must provide an implementation for the `create` method,
/// which returns a middleware function.
///
/// Example usage:
///
/// ```dart
/// class LoggerMiddlewareFactory implements MiddlewareFactory {
///   @override
///   Middleware create() {
///     return (Request request, Response response, void Function() next) {
///       print('Request: ${request.method} ${request.uri}');
///       next();
///     };
///   }
/// }
///
/// void main() {
///   final app = App();
///
///   app.registerMiddleware('logger', LoggerMiddlewareFactory());
///   app.useMiddleware('logger');
///
///   app.get('/hello', (Request request, Response response) {
///     response.send('Hello, world!');
///   });
///
///   app.listen(address: 'localhost', port: 8080);
/// }
/// ```
abstract class MiddlewareFactory {
  /// Creates a middleware function.
  ///
  /// Returns a `Middleware` function that processes a request, a response, and a `next` callback.
  Middleware create();
}
