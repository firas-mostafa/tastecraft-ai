import 'package:dio/dio.dart' show Response;

class ErrorModel {
  final int? status;
  final String errorMessage;

  ErrorModel({required this.status, required this.errorMessage});
  factory ErrorModel.fromResponse(Response jsonData) {
    final Map<String, dynamic> errorData = jsonData.data;
    final List<String> errorList = [];
    errorData.forEach((key, value) {
      final formattedKey = key.replaceAll('_', ' ');
      if (value is List) {
        for (var error in value) {
          errorList.add('$formattedKey:\n$error');
        }
      } else if (value is String) {
        errorList.add('$formattedKey:\n$value');
      }
    });
    final errorMessege = StringBuffer();

    for (var error in errorList) {
      errorMessege.writeln(error);
    }
    return ErrorModel(
      status: jsonData.statusCode,
      errorMessage: errorMessege.toString(),
    );
  }
}
