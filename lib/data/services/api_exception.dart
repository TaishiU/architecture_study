class ApiClientException implements Exception {
  final String message;
  final int? statusCode;

  ApiClientException(this.message, {this.statusCode});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiClientException: $message (Status Code: $statusCode)';
    }
    return 'ApiClientException: $message';
  }
}

class BadRequestException extends ApiClientException {
  BadRequestException(String message, {int? statusCode})
      : super('Bad Request: $message', statusCode: statusCode ?? 400);
}
class UnauthorizedException extends ApiClientException {
  UnauthorizedException(String message, {int? statusCode})
      : super('Unauthorized: $message', statusCode: statusCode ?? 401);
}
class ForbiddenException extends ApiClientException {
  ForbiddenException(String message, {int? statusCode})
      : super('Forbidden: $message', statusCode: statusCode ?? 403);
}
class NotFoundException extends ApiClientException {
  NotFoundException(String message, {int? statusCode})
      : super('Not Found: $message', statusCode: statusCode ?? 404);
}
class MethodNotAllowedException extends ApiClientException {
  MethodNotAllowedException(String message, {int? statusCode})
      : super('Method Not Allowed: $message', statusCode: statusCode ?? 405);
}
class InternalServerErrorException extends ApiClientException {
  InternalServerErrorException(String message, {int? statusCode})
      : super('Internal Server Error: $message', statusCode: statusCode ?? 500);
}
class NoInternetConnectionException extends ApiClientException {
  NoInternetConnectionException(String message)
      : super('No Internet Connection: $message');
}
class UnknownErrorException extends ApiClientException {
  UnknownErrorException(String message, {int? statusCode})
      : super('Unknown Error: $message', statusCode: statusCode);
}
