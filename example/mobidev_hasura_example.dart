import 'package:mobidev_hasura/src/hasura.dart';
final String endpoint = "https://gql.mobidev.com.br/v1/graphql";
final String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiYWRtaW4iOnRydWUsImlhdCI6MTUxNjIzOTAyMiwiaHR0cHM6Ly9oYXN1cmEuaW8vand0L2NsYWltcyI6eyJ4LWhhc3VyYS1kZWZhdWx0LXJvbGUiOiJ1c2VyIiwieC1oYXN1cmEtYWxsb3dlZC1yb2xlcyI6WyJ1c2VyIl0sIngtaGFzdXJhLXVzZXItaWQiOiIwIiwieC1oYXN1cmEtb3JnLWlkIjoiNDU2IiwieC1oYXN1cmEtY3VzdG9tIjoiMCIsIngtaGFzdXJhLXRhYmxlIjoidGVzdGUifX0.QgWHpsDp247sWMKwLcA3k4VURh9T7Kh57kXIE9AcUcs";
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
