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
      rethrow;
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
    this.request = VGSHttpRequest.post,
  });

  final String vaultId;
  final String path;
  final bool sandbox;
  final Map<String, String> headers;
  final Map<String, dynamic> data;
  final VGSHttpRequest request;

  Map<String, Object> toMap() {
    return {
      'vaultId': vaultId,
      'sandbox': sandbox,
      'headers': headers,
      'path': path,
      'data': data,
      'request': stringifyRequest(request),
    };
  }

  String stringifyRequest(VGSHttpRequest request) {
    switch (request) {
      case VGSHttpRequest.post:
        return 'POST';
      case VGSHttpRequest.put:
        return 'PUT';
      case VGSHttpRequest.get:
        return 'GET';
      case VGSHttpRequest.delete:
        return 'DELETE';
      case VGSHttpRequest.patch:
        return 'PATCH';
    }
  }
}

enum VGSHttpRequest { post, put, get, delete, patch }
