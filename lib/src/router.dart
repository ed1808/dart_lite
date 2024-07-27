import 'handler.dart';

/// The `Router` class is responsible for managing routes and their corresponding handlers.
class Router {
  /// A private map to store routes and their handlers.
  /// The map's key is an HTTP method (e.g., GET, POST), and its value is another map.
  /// The inner map's key is a path (e.g., "/users") and its value is a `Handler`.
  final Map<String, Map<String, Handler>> _routes = {};

  /// Adds a route to the router.
  ///
  /// [method]: The HTTP method for the route (e.g., "GET", "POST").
  /// [path]: The path for the route (e.g., "/users").
  /// [handler]: The handler function to be called when the route is matched.
  ///
  /// If the method does not already exist in the `_routes` map, a new map is created for it.
  /// The handler is then added to the inner map for the specified path.
  void addRoute(String method, String path, Handler handler) {
    if (!_routes.containsKey(method)) {
      _routes[method] = {};
    }

    _routes[method]![path] = handler;
  }

  /// Retrieves a route's handler based on the HTTP method and path.
  ///
  /// [method]: The HTTP method for the route (e.g., "GET", "POST").
  /// [path]: The path for the route (e.g., "/users").
  ///
  /// Returns the `Handler` if the route is found, or `null` if it is not.
  Handler? getRoute(String method, String path, Map<String, String> params) {
    if (_routes.containsKey(method)) {
      for (final route in _routes[method]!.keys) {
        final regExpPattern = RegExp('^' + route.replaceAllMapped(RegExp(r':(\w+)'), (match) {
          return r'(?<' + match.group(1)! + r'>\w+)';
        }) + r'$');

        final match = regExpPattern.firstMatch(path);

        if (match != null) {
          for (final groupName in match.groupNames) {
            params[groupName] = match.namedGroup(groupName)!;
          }
          return _routes[method]![route];
        }
      }
    }
    return null;
  }
}
