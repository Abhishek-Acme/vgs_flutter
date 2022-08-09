import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:vgs_flutter/vgs_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('VGS Flutter Demo'),
        ),
        body: Builder(builder: (context) {
          return Center(
            child: ElevatedButton(
              child: const Text('Send Data'),
              onPressed: () async {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const SizedBox.square(
                              dimension: 30,
                              child: CircularProgressIndicator(strokeWidth: 1),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Sending data ...',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                final response = await VGSFlutter.send(
                  data: VGSCollectData(
                    request: VGSHttpRequest.post,
                    vaultId: <vault-id>,
                    path: '/cards',
                    sandbox: true,
                    headers: {
                      'Authorization':
                          'Bearer eyJraWQiOiJTWWYweldVR1dGTnBxSHE4YjBZZDMxS2tRdjJYcmVGOG8yV0V5T1wvb1hHMD0iLCJhbGciOiJSUzI1NiJ9.eyJzdWIiOiI2NGQ5N2E1My00MzNmLTRlMDItOTI5MC1lMTU1MGM1ZTQ5MGYiLCJhdWQiOiI3ZTBpbWVwcjU0MXRpdGdtczJuMHZlMmU1cCIsImV2ZW50X2lkIjoiMmQzNTEyMTgtODFiZS00ODFlLWI1NjItMDc1MmJhZjFiNGQyIiwidG9rZW5fdXNlIjoiaWQiLCJjdXN0b206cGVyY2hfaWQiOiIxMDg4ZWQ4Yy04ZTcyLTRkYTAtODFkZi1kMDNhZmE1YmNlMzUiLCJhdXRoX3RpbWUiOjE2NDYzMTUyMDcsImlzcyI6Imh0dHBzOlwvXC9jb2duaXRvLWlkcC51cy13ZXN0LTIuYW1hem9uYXdzLmNvbVwvdXMtd2VzdC0yXzBDd2Y5c1N0SCIsImNvZ25pdG86dXNlcm5hbWUiOiI2NGQ5N2E1My00MzNmLTRlMDItOTI5MC1lMTU1MGM1ZTQ5MGYiLCJjdXN0b206cGVyY2hfcm9sZSI6IlVTRVIiLCJleHAiOjE2NDYzMTg4MDcsImlhdCI6MTY0NjMxNTIwNywiZW1haWwiOiJmcm9udGVuZCs1MEBnZXRwZXJjaC5hcHAifQ.C7H9LzbM0EKqPrWCIEWja4RvXa1DrD19wGHo1ZrVx113Pbl21oLEtExnEgVAMy6NAhOTwBUerCJbzO6WH08bqb4LwXd4-Ug0Mrbvq775W2oSuQdl3nf82IhhTXajY4i9yjdJN0ugx0kqMy4aWpnvzJtQQQ-rGc3IJe6eHDvyVYHFsBbe1qosknvL2zYpRvzwg66PJnhu9vlxjtYwJbpKKYA2kqsl4-67WOYDYVs7KNV9bRQ9IUG-Fqhr4YoyNDmJnAn3ExmbVh0hjQ9MBwiA0RPd9_LtyunfLWPUO0Vx',
                    },
                    data: {
                      'attributes': {
                        'cvv2': '1234',
                        'expiration-date': '02/2012',
                      }
                    },
                  ),
                );
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Data Sent!!',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                log(response.toString(), name: 'Response');
              },
            ),
          );
        }),
      ),
    );
  }
}
