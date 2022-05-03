import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vgs_flutter/vgs_flutter.dart';

void main() {
  const MethodChannel channel = MethodChannel('vgs_flutter');

  TestWidgetsFlutterBinding.ensureInitialized();

  final extraData = {
    'query': 'query',
    'variables': {'userId': 'user-id'},
  };

  final correctData = VGSCollectData(
    vaultId: 'correct-id',
    path: 'path',
    sandbox: true,
    headers: {'Authrorization': 'Bearer Token'},
    data: extraData,
  );

  final incorrectData = VGSCollectData(
    vaultId: 'incorrect-id',
    path: 'path',
    sandbox: true,
    headers: {'Authrorization': 'Bearer Token'},
    data: extraData,
  );

  Map<String, Object>? _platformArgs;

  setUp(() {
    channel.setMockMethodCallHandler(
      (call) async {
        if (call.method == 'sendData') {
          final vaultId = call.arguments['vaultId'];
          _platformArgs = Map.from(call.arguments);

          if (vaultId == 'correct-id') return 'success';

          throw PlatformException(code: 'INVALID_VAULT_ID');
        }
        throw UnimplementedError();
      },
    );
  });

  test('happy path', () async {
    final response = await VGSFlutter.send(data: correctData);

    expect(
      _platformArgs,
      {
        'vaultId': 'correct-id',
        'sandbox': true,
        'headers': {'Authrorization': 'Bearer Token'},
        'path': 'path',
        'data': {
          'query': 'query',
          'variables': {'userId': 'user-id'},
        }
      },
    );

    expect(response, equals('success'));
  });

  test('platform exception', () async {
    final response = await VGSFlutter.send(data: incorrectData);

    expect(response, isNull);
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });
}
