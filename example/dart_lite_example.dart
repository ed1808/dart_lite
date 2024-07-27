import 'dart:io';
import 'dart:math';

import 'package:dart_lite/dart_lite.dart';
import 'package:dart_lite/dart_lite_server.dart';

void main() {
  final App app = App();

  app.registerMiddleware(name: 'logger', factory: LoggerMiddlewareFactory());
  /* app.registerMiddleware(
      name: 'jwtValidator',
      factory: JwtValidatorMiddlewareFactory('secret_key')); */

  app.useMiddleware('logger');
  // app.useMiddleware('jwtValidator');

  app.register<UsersService>(UsersService());

  app.get('/', (Request request, Response response) async {
    response.json({"message": "Root"});
  });

  app.get('/users', (Request request, Response response) {
    final UsersService usersService = app.resolve<UsersService>();
    final List<Map<String, dynamic>> users = usersService.getUsers();
    response.json({"users": users});
  });

  app.get('/users/:id', (Request request, Response response) async {
    final Map<String, dynamic> reqBody = await request.read();
    final UsersService usersService = app.resolve<UsersService>();
    final User? user =
        usersService.getUserById(int.parse(reqBody['req_params']['id']));

    if (user == null) {
      response.status(HttpStatus.notFound);
      response.json({"message": "User not found"});
    } else {
      response.json({"user": user.asJson()});
    }
  });

  app.post('/users', (Request request, Response response) async {
    final Map<String, dynamic> reqBody = await request.read();
    final Map<String, dynamic> userData = {
      "username": reqBody['username'],
      "password": makePassword(reqBody['password'], 'my_secret_key')
    };

    final UsersService usersService = app.resolve<UsersService>();
    final User createdUser = usersService.createUser(userData);

    response.json({"user": createdUser.asJson()});
  });

  app.listen(address: '127.0.0.1', port: 8080);
}

class UsersService {
  final List<User> _userDb = [];

  List<Map<String, dynamic>> getUsers() {
    return _userDb.map((user) => user.asJson()).toList();
  }

  User? getUserById(int userId) {
    for (final user in _userDb) {
      if (user.id == userId) {
        return user;
      }
    }
    return null;
  }

  User createUser(Map<String, dynamic> json) {
    final newUser = User.fromJson(json);
    _userDb.add(newUser);

    return newUser;
  }
}

class User {
  final int _id;
  final String _username;
  final String _password;

  User(String username, String password)
      : _id = Random().nextInt(100),
        _username = username,
        _password = password;

  User.fromJson(Map<String, dynamic> json)
      : _id = Random().nextInt(100),
        _username = json['username'],
        _password = json['password'];

  String get username => _username;
  int get id => _id;
  String get password => _password;

  Map<String, dynamic> asJson() {
    return {"id": _id, "username": _username, "password": _password};
  }

  @override
  String toString() {
    return '{"id": $_id, "username": $_username, "password": $_password}';
  }
}
