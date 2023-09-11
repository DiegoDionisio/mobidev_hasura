import 'package:mobidev_hasura/src/hasura.dart';
final String endpoint = "";
final String token = "";
void main() async {
  Hasura hasura = Hasura(endpoint: endpoint, token: token);
  await _upsertTest(hasura);
  await _queryTest(hasura);
}

Future<void> _upsertTest(Hasura hasura) async {
  var response = await hasura.upsert(
    table: 'teste_one', 
    object: {"name": "ddddd", "code": 17}, 
    constraint: 'teste_name_key', 
    onConflictUpdateColumns: {'code'}, 
    returning: {'id', 'name', 'code'}
  );

  if(response.isOk) {
    var t1 = response.body;
    var t2 = response.rawResponse;
    if(t1.isNotEmpty){

    }
  }
}

Future<void> _queryTest(Hasura hasura) async {
  var response = await hasura.query(
    table: 'teste', 
    fields: {
    'id',
    'name'
    }, 
  );

  if(response.isOk) {
    var t1 = response.body;
    var t2 = response.items.map((e) => e['name'].toString()).toList();
    if(t2.isNotEmpty && t1.isNotEmpty) {

    }
  }
}
