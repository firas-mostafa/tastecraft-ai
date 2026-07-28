import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:recipe_app/core/errors/error_model.dart' show ErrorModel;

class ServerException implements Exception {
  final ErrorModel errorModel;

  ServerException({required this.errorModel});
}

void handleDioExceptions(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.sendTimeout:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.receiveTimeout:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.badCertificate:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.cancel:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.connectionError:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.unknown:
      throw ServerException(errorModel: ErrorModel.fromResponse(e.response!));
    case DioExceptionType.badResponse:
      switch (e.response?.statusCode) {
        case 400: // Bad request
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 401: //unauthorized
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 403: //forbidden
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 404: //not found
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 409: //cofficient
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 422: //  Unprocessable Entity
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 500: // Internal Server Error
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
        case 504: // Server exception
          throw ServerException(
            errorModel: ErrorModel.fromResponse(e.response!),
          );
      }
  }
}
