/// The `DIContainer` class is a simple Dependency Injection (DI) container.
/// It allows registering and resolving instances by their type.
class DIContainer {
  /// A private map that stores instances by their type.
  final Map<Type, dynamic> _instances = {};

  /// Registers an instance in the container.
  ///
  /// [instance]: The instance to be registered. Its type is inferred from the generic parameter [T].
  ///
  /// Example:
  /// ```
  /// var container = DIContainer();
  /// container.register<MyClass>(MyClass());
  /// ```
  void register<T>(T instance) {
    _instances[T] = instance;
  }

  /// Resolves an instance from the container by its type.
  ///
  /// Returns the registered instance of type [T].
  /// Throws an exception if no instance is registered for the type [T].
  ///
  /// Example:
  /// ```
  /// var myClassInstance = container.resolve<MyClass>();
  /// ```
  ///
  /// Throws:
  /// - Exception: If no instance is registered for the type [T].
  T resolve<T>() {
    final instance = _instances[T];

    if (instance == null) {
      throw Exception("No instance registered for type $T");
    }

    return instance;
  }
}
