import 'dart:io';

import '../api_request.dart';
import '../middleware.dart';
import '../request.dart';
import '../response.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class JwtValidatorMiddlewareFactory implements MiddlewareFactory {
  final String _secretKey;

  JwtValidatorMiddlewareFactory(this._secretKey);

  @override
  Middleware create() {
    return (Request request, Response response, void Function(Request req, Response res) next) {
      final String? authHeader = request.headers.value(HttpHeaders.authorizationHeader);

      if (authHeader == null || !authHeader.startsWith('Bearer')) {
        response.status(HttpStatus.unauthorized);
        response.json({"message": "Missing or invalid authorization header"});
        return;
      }

      final String token = authHeader.substring(7);

      try {
        final JWT jwt = JWT.verify(token, SecretKey(_secretKey));
        final ApiRequest apiRequest = ApiRequest(request.raw, jwt.payload);

        next(apiRequest, response);
      } on JWTExpiredException {
        response.status(HttpStatus.unauthorized);
        response.json({"message": "Expired token"});
        return;
      } on JWTException catch (e) {
        response.status(HttpStatus.unauthorized);
        response.json({"message": e.message});
        return;
      } catch (err) {
        response.status(HttpStatus.internalServerError);
        response.json({"message": err});
        return;
      }
    };
  }
}