// import 'package:classist/_base/failures.dart';
// import 'package:dio/dio.dart';

// import 'error_api_helper.dart';
// import 'locale_dio_exceptions.dart';

// class ErrorApiModel extends Failure {
//   final bool isMessageLocalizationKey;
//   final String message;
//   final int code;

//   ErrorApiModel({
//     required this.isMessageLocalizationKey,
//     required this.message,
//     required this.code,
//   });

//   factory ErrorApiModel.fromDioError(DioError dioError) {
//     late int codeError;
//     switch (dioError.type) {
//       case DioExceptionType.cancel:
//         codeError = 1001;
//         break;
//       case DioExceptionType.sendTimeout:
//         codeError = 1002;
//         break;
//       case DioExceptionType.receiveTimeout:
//         codeError = 1003;
//         break;
//       case DioExceptionType.badResponse:
//         // use code from 1004 - 1010
//         codeError = ErrorApiHelper.handleResponseErrorCode(
//           dioError.response?.statusCode,
//         );
//         break;
//       case DioExceptionType.sendTimeout:
//         codeError = 1011;

//         break;
//       case DioExceptionType.unknown:
//         if (dioError.message?.contains("SocketException") ?? false) {
//           codeError = 1012;
//           break;
//         }
//         codeError = 1013;
//         break;
//       default:
//         codeError = 1014;
//         break;
//     }
//     if (codeError == 1007) {
//       return ErrorApiModel.fromJson(dioError);
//     } else {
//       return ErrorApiModel(
//           code: codeError,
//           isMessageLocalizationKey: true,
//           message: LocaleDioExceptions.getLocaleMessage(codeError));
//     }
//   }

//   factory ErrorApiModel.identifyError({dynamic error}) {
//     ErrorApiModel errorApiModel;
//     String? stackTrace = "";
//     if (error is TypeError) {
//       stackTrace = error.stackTrace.toString();
//       errorApiModel = ErrorApiModel(
//           code: 1015,
//           message:
//               ErrorApiHelper.formErrorMessage(error.toString(), stackTrace),
//           isMessageLocalizationKey: false);
//     } else {
//       errorApiModel = ErrorApiModel(
//           code: 1015,
//           message: LocaleDioExceptions.getLocaleMessage(1015),
//           isMessageLocalizationKey: true);
//     }
//     return errorApiModel;
//   }

//   factory ErrorApiModel.fromJson(DioException error) {
//     Map<String, dynamic> extractedData =
//         error.response?.data as Map<String, dynamic>;
//     return ErrorApiModel(
//         code: error.response?.statusCode ?? 1007,
//         message: extractedData["Message"],
//         isMessageLocalizationKey: false);
//   }
// }
