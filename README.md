<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->


Easily execute Hasura's query and mutations, without the need of any other package.

## Features

- Query
- Upsert (mutation)
- rawQuery
- rawMutation

## Getting started

Add **mobidev_hasura** to your pubspec.yaml

import the package:
```
import 'package:mobidev_hasura/mobidev_hasura.dart';
```

## Usage

```dart
    var hasura = Hasura(
        endpoint: 'https://myendpoint.com/v1/graphql',
        token: 'my jwt token here'
    );

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
```

## Additional information

This is the initial release.

New features will be added soon.
