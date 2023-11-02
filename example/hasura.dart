import 'package:mobidev_hasura/mobidev_hasura.dart';

void main() async {
  var hasura = Hasura(
      endpoint: 'https://myendpoint.com/v1/graphql',
      token: 'my jwt token here');

  var result = await hasura.query(table: 'customers', fields: {
    'name',
    'address',
    'phone'
  }, where: {
    'name': {'_eq': 'josh'}
  });

  if (result.isOk) {
    Map<String, dynamic> myRetrievedData = result.body;
    //Do anything with your data
  }
}
