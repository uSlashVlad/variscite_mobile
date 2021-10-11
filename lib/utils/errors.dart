abstract class ApiError extends Error {}

class ValidationError extends ApiError {
  static const statusCode = 400;
}

class AuthError extends ApiError {
  static const statusCode = 401;
}

class NoPermissionError extends ApiError {
  static const statusCode = 403;
}

class NotFoundError extends ApiError {
  static const statusCode = 404;
}

class InternalServerError extends ApiError {
  static const statusCode = 500;
}

void throwErrorByStatusCode(int statusCode) {
  switch (statusCode) {
    case ValidationError.statusCode:
      throw ValidationError();
    case AuthError.statusCode:
      throw AuthError();
    case NoPermissionError.statusCode:
      throw NoPermissionError();
    case NotFoundError.statusCode:
      throw NotFoundError();
    case InternalServerError.statusCode:
      throw InternalServerError();
  }
}
