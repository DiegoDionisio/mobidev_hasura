import 'package:dio/dio.dart';

abstract interface class IResponse {
  bool get isOk;
  int get count;
  int get statusCode;
  String get statusMessage;
  Response? get rawResponse;
  List get items;
  Map<String, dynamic> get body;
}
