import 'request.dart';
import 'response.dart';

/// A `Handler` is a function that processes an HTTP request and generates a response.
///
/// [request]: The `Request` object representing the incoming HTTP request.
/// [response]: The `Response` object used to send a response back to the client.
typedef Handler = void Function(Request request, Response response);
