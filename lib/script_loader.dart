import 'dart:convert';

import 'package:crypton/crypton.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

Future<String> loadScriptFromAsset() async {
  // for now read script from asset
  return await rootBundle.loadString('assets/scripts/obstacles.lua');
}

Future<String> loadScriptFromNetwork() async {
  const scriptUrl = kDebugMode ? "http://localhost:8080" : "https://ci-to-dangerzone.web.app";

  late final String script;

  final response = await http.get(Uri.parse("$scriptUrl/obstacles.lua"));
  script = response.body;

  final response2 = await http.get(Uri.parse("$scriptUrl/signature"));
  final signatureString = response2.body;

  final publicKeyString = await rootBundle.loadString("assets/public_key");
  final publicKey = RSAPublicKey.fromString(publicKeyString);
  final signatureFromFile = base64.decode(signatureString);
  final verified = publicKey.verifySHA256Signature(
    utf8.encode(script) as Uint8List,
    signatureFromFile,
  );

  if (!verified) {
    throw Exception("invalid code signature");
  }

  return script;
}
