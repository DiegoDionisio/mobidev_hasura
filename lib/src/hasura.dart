import 'package:dio/dio.dart';
import 'package:mobidev_hasura/src/extensions.dart';
import 'package:mobidev_hasura/src/gql_compressor.dart';
import 'package:mobidev_hasura/src/providers/hasura_reponse.dart';
import 'package:mobidev_hasura/src/providers/i_response.dart';

class Hasura {
  final String _endpoint;
  final String? token;

  Hasura({required String endpoint, this.token}) : _endpoint = endpoint;

  Future<IResponse> query({
    required String table,
    Map<String, dynamic>? where,
    Map<String, String>? headers,
    required Set<dynamic> fields

  }) async {
    
    var gqlQuery = _createQuery(table, where ?? {}, fields);
    print(gqlQuery);
    var response = await _execute(gqlQuery, headers: headers);
    return HasuraReponse(response);
  }

  Future<IResponse> upsert({
    required String table,
    required Map<String, dynamic> object,
    required String constraint,
    required Set<String> onConflictUpdateColumns,
    required Set<String> returning,
    Map<String, String>? headers,
  }) async {
    
    var gqlQuery = _createUpsert(table, object, constraint, onConflictUpdateColumns, returning);
    print(gqlQuery);
    var response = await _execute(gqlQuery, headers: headers);
    return HasuraReponse(response);
  }

  Future<IResponse> upsertAll({
    required String table,
    required List<dynamic> objects,
    required Map<String, dynamic> where,
    required Set<String> onConflictUpdateColumns,
    required Set<String> returning,
    Map<String, String>? headers,
  }) async {
    String gqlQuery = _createUpsertAll(table, objects, where, onConflictUpdateColumns, returning);
    var response = await _execute(gqlQuery, headers: headers);
    return HasuraReponse(response);
  }

  Future<Response> _execute(String gqlQuery, {Map<String, String>? headers}) async {
    Map<String, String> tmpHeaders = headers ?? {};
    if(token != null && !tmpHeaders.keys.map((e) => e.toLowerCase()).contains('authorization')) {
      tmpHeaders.addAll({'Authorization' : "Bearer $token"});
    }
    return await Dio().post(_endpoint, data: {"query" : gqlQuery}, options: Options(headers: tmpHeaders));
  }

  String _createQuery(String table, Map<String, dynamic> where, Set<dynamic> returning) {
    String tmpWhere = '';
    if(where.isNotEmpty) {
      tmpWhere = '(where: ${where.xToHasura()})';
    }
    var gqlQuery = '''
    query $table${'_'}query {
      $table$tmpWhere {
        ${returning.join('\n')}
      }
    }
    ''';
    return GraphqlQueryCompressor().call(gqlQuery);
  }

  String _createUpsert(table, Map<String, dynamic> object, String constraint, Set<String> onConflictUpdateColumns, Set<String> returning) {
    String upsertConstraint  = constraint.isEmpty  ? '' : ', on_conflict: {constraint: $constraint, update_columns: [${onConflictUpdateColumns.join(',')}]}';
    var gqlUpsert = '''
      mutation upsertMutation {
        insert_$table${'_one'}(object: ${object.xToHasura()}$upsertConstraint) {
          ${returning.join('\n')}
        }
      }
    ''';
    return gqlUpsert;

  }

   String _createUpsertAll(table, List<dynamic> objects, Map<String, dynamic> where, Set<String> onConflictUpdateColumns, Set<String> returning) {
    String upsertConstraint  = onConflictUpdateColumns.isEmpty  ? '' : ', on_conflict: {constraint: where: ${where.xToHasura()}, update_columns: [${onConflictUpdateColumns.join(',')}]}';
    var gqlUpsert = '''
      mutation upsertAllMutation {
        insert_$table(objects: ${objects.toList()}$upsertConstraint) {
          ${returning.join('\n')}
        }
      }
    ''';
    return gqlUpsert;

  }

  Future<IResponse> rawQuery({required String graphqlQuery, Map<String, String>? headers}) async {
    var response = await _execute(graphqlQuery, headers: headers);
    return HasuraReponse(response);
  }

  Future<IResponse> rawQMutation({required String graphqlQuery, Map<String, String>? headers}) async {
    return rawQuery(graphqlQuery: graphqlQuery, headers: headers);
  }
}