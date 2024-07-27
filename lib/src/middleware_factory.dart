import 'middleware.dart';

class MiddlewareRegistry {
  final Map<String, MiddlewareFactory> _factories = {};

  void register({required String name, required MiddlewareFactory factory}) {
    _factories[name] = factory;
  }

  Middleware create(String name) {
    final factory = _factories[name];

    if (factory == null) {
      throw Exception("No middleware factory registered for $name");
    }

    return factory.create();
  }
}
