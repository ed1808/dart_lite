<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

Dart Lite is a lightweight web framework designed for simplicity and flexibility in building web applications with Dart. It aims to provide a straightforward approach to handling HTTP requests, routing, and middleware, allowing developers to focus on building robust and maintainable web applications.

> **This project is currently under development.**

## Features

- **Simple Routing**: Easily define routes for various HTTP methods (GET, POST, PUT, PATCH, DELETE) and handle dynamic URL parameters.

- **Middleware Support**: Implement custom middleware for request preprocessing, logging, authentication, and more.

- **Dependency Injection**: Manage and inject dependencies seamlessly using a built-in DI container.

- **Request and Response Abstraction**: Simplified API for handling HTTP requests and responses.

- **JWT Authentication**: Built-in support for validating JSON Web Tokens (JWT) and adding the payload to requests.

## Usage

```dart
import 'package:dart_lite/dart_lite.dart';
import 'package:dart_lite/dart_lite_server.dart';

void main() {
    final App app = App();

    // Register a middleware to be used later.
    app.registerMiddleware(name: 'logger', factory: LoggerMiddlewareFactory());

    // Tells the server wich middleware to be used after being registered.
    app.useMiddleware('logger');

    app.get('/', (Request req, Response res) {
        res.json({"message": "Hello from DartLite"});
    });

    app.listen(address: '127.0.0.1', port: 8080);
}
```

