import 'package:dio/dio.dart';
import 'package:nike_store/common/exception.dart';

mixin HttpResponseValidator{
  validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}