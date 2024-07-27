import 'dart:io';

import 'dart_lite.dart';

/// The `App` class represents a web application.
/// It provides methods to define routes and middleware, and to start an HTTP server.
class App {
  /// A router to manage the application's routes.
  final Router _router = Router();

  /// A list of middleware functions to be executed before handling requests.
  final List<Middleware> _middlewares = [];

  /// A dependency injection container to manage instances of classes.
  final DIContainer _diContainer = DIContainer();

  /// A registry to manage middleware factories.
  final MiddlewareRegistry _middlewareRegistry = MiddlewareRegistry();

  /// Adds a middleware to the application.
  ///
  /// [middleware]: The middleware function to add.
  void use(Middleware middleware) {
    _middlewares.add(middleware);
  }

  /// Registers a middleware factory.
  ///
  /// [name]: The name of the middleware.
  /// [factory]: The factory instance to register.
  void registerMiddleware(
      {required String name, required MiddlewareFactory factory}) {
    _middlewareRegistry.register(name: name, factory: factory);
  }

  /// Adds a middleware to the application by its factory name.
  ///
  /// [name]: The name of the middleware factory.
  void useMiddleware(String name) {
    final middleware = _middlewareRegistry.create(name);
    use(middleware);
  }

  /// Adds a route to the application.
  ///
  /// [method]: The HTTP method for the route (e.g., "GET", "POST").
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void addRoute(String method, String path, Handler handler) {
    _router.addRoute(method, path, handler);
  }

  /// Adds a GET route to the application.
  ///
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void get(String path, Handler handler) {
    addRoute('GET', path, handler);
  }

  /// Adds a POST route to the application.
  ///
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void post(String path, Handler handler) {
    addRoute('POST', path, handler);
  }

  /// Adds a PUT route to the application.
  ///
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void put(String path, Handler handler) {
    addRoute('PUT', path, handler);
  }

  /// Adds a PATCH route to the application.
  ///
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void patch(String path, Handler handler) {
    addRoute('PATCH', path, handler);
  }

  /// Adds a DELETE route to the application.
  ///
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  void delete(String path, Handler handler) {
    addRoute('DELETE', path, handler);
  }

  /// Registers a class instance in the dependency injection container.
  ///
  /// [classInstance]: The instance to be registered. Its type is inferred from the generic parameter [T].
  void register<T>(T classInstance) {
    _diContainer.register(classInstance);
  }

  /// Resolves an instance from the dependency injection container by its type.
  ///
  /// Returns the registered instance of type [T].
  /// Throws an exception if no instance is registered for the type [T].
  ///
  /// Example:
  /// ```
  /// var myClassInstance = app.resolve<MyClass>();
  /// ```
  ///
  /// Throws:
  /// - Exception: If no instance is registered for the type [T].
  T resolve<T>() {
    return _diContainer.resolve<T>();
  }

  /// Starts the HTTP server and listens for incoming requests.
  ///
  /// [address]: The address on which the server will listen.
  /// [port]: The port on which the server will listen.
  ///
  /// The server processes each request by running the registered middleware
  /// in sequence and then matching the request to a route handler.
  Future<void> listen({required String address, required int port}) async {
    final server = await HttpServer.bind(address, port);

    print("Server running on ${server.address.address}:${server.port}");

    await for (HttpRequest httpRequest in server) {
      final Map<String, String> params = {};
      final request = Request(httpRequest);
      final response = Response(httpRequest.response);

      int middlewareIndex = -1;

      void next(Request request, Response response) {
        middlewareIndex++;

        if (middlewareIndex < _middlewares.length) {
          _middlewares[middlewareIndex](request, response, next);
        } else {
          final handler = _router.getRoute(request.method, request.uri.path, params);

          if (handler != null) {
            request.addParamsToBody(params);
            handler(request, response);
          } else {
            response.status(HttpStatus.notFound);
            response.json({"message": "Not found"});
          }
        }
      }

      next(request, response);
    }
  }
}
