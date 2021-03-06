import 'dart:async';

import 'package:flutter/services.dart';

const MethodChannel _channel =
    const MethodChannel('juanito21.com/simple_rsa');

Future<String> encryptString(String txt, String publicKey) async {
  try {
    final String result = await _channel
        .invokeMethod('encrypt', {"txt": txt, "publicKey": publicKey});
    return result;
  } on PlatformException catch (e) {
    throw "Failed to get string encoded: '${e.message}'.";
  }
}

Future<String> decryptString(String txt, String privateKey) async {
  try {
    final String result = await _channel
        .invokeMethod('decrypt', {"txt": txt, "privateKey": privateKey});
    return result;
  } on PlatformException catch (e) {
    throw "Failed decoded string: '${e.message}'.";
  }
}
