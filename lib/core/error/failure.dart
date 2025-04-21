import 'package:dio/dio.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.errMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('انتهت مهلة الاتصال مع الخادم');

      case DioExceptionType.sendTimeout:
        return ServerFailure('انتهت مهلة إرسال البيانات إلى الخادم');

      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioError.response!.statusCode, dioError.response!.data);

      case DioExceptionType.receiveTimeout:
        return ServerFailure('انتهت مهلة استلام البيانات من الخادم');

      case DioExceptionType.cancel:
        return ServerFailure('تم إلغاء الطلب إلى الخادم');

      case DioExceptionType.connectionError:
        return ServerFailure('خطأ في الاتصال');

      case DioExceptionType.unknown:
        if ((dioError.message ?? '').contains('SocketException')) {
          return ServerFailure('لا يوجد اتصال بالإنترنت');
        }

        return ServerFailure('حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى!');

      default:
        return ServerFailure('عذرًا، حدث خطأ ما، يرجى المحاولة مرة أخرى');
    }
  }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure(response['message']);
    } else if (statusCode == 404) {
      return ServerFailure('لم يتم العثور على الطلب، يرجى المحاولة لاحقًا!');
    } else if (statusCode == 500) {
      return ServerFailure('خطأ في الخادم الداخلي، يرجى المحاولة لاحقًا');
    } else {
      return ServerFailure('عذرًا، حدث خطأ ما، يرجى المحاولة مرة أخرى');
    }
  }
}