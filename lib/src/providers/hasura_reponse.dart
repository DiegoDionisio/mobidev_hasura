import 'package:mobidev_hasura/src/providers/i_response.dart';
import 'package:dio/dio.dart';

class HasuraReponse implements IResponse {
  int? _statusCode;
  String? _statusMessage;
  Map<String, dynamic> _body = {};
  List _items = [];  
  Response? _rawResponse;

  HasuraReponse(Response response) {
    _rawResponse = response;
    _decode();
  }

  @override
  bool get isOk => [200,201,202].contains(statusCode);

  @override
  int get count => items.length;

  @override
  int get statusCode => _statusCode ?? _rawResponse?.statusCode ?? 0;

  @override
  String get statusMessage => _statusMessage ?? _rawResponse?.statusMessage ?? '';

  @override
  Map<String, dynamic> get body => _body;

  @override
  Response? get rawResponse => _rawResponse;

  @override
  List get items => _items;

  void _decode() async {
    if(isOk) {
      Map<String, dynamic> tmp = _rawResponse?.data ?? {};
      if(tmp.isNotEmpty && tmp.containsKey('data')) {
        _body = tmp['data'] ?? {};
        if(body.isNotEmpty) {
          if(body.keys.first.startsWith('insert_')) {
            _body = {
              body.keys.first.replaceAll('insert_', '') : body.entries.first.value 
            };
          }
        }
        if(_body.entries.first.value is List) {
          _items = _body.entries.first.value;
        }
      } else if(tmp.isNotEmpty && tmp.containsKey('errors')) {
        _statusCode = 400;
        Map<String, dynamic> error = (tmp['errors'] as List)[0];
        if(error.containsKey('message')) {
          _statusMessage = 'Bad Request: ${error['message']}';
          if(_statusMessage != null) {

          }
        }
      }
    }
  }

}