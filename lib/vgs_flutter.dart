import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';

class VGSFlutter {
  static const MethodChannel _channel = MethodChannel('vgs_flutter');

  static Future<String?> send({required VGSCollectData data}) async {
    try {
      return await _channel.invokeMethod<String>('sendData', data.toMap());
    } on PlatformException catch (e) {
      log('VGS Exception: $e');
      return null;
    }
  }
}

class VGSCollectData {
  VGSCollectData({
    required this.vaultId,
    required this.path,
    required this.sandbox,
    required this.headers,
    required this.data,
  });

  final String vaultId;
  final String path;
  final bool sandbox;
  final Map<String, String> headers;
  final Map<String, dynamic> data;

  Map<String, Object> toMap() {
    return {
      'vaultId': vaultId,
      'sandbox': sandbox,
      'headers': headers,
      'path': path,
      'data': data,
    };
  }
}
