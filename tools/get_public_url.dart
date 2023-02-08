#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

/// Expect to have CM_API_TOKEN env var set with a Codemagic API Token
/// see: https://docs.codemagic.io/rest-api/codemagic-rest-api/#authentication

void main(List<String> args) {
  final artifactsJsonString = exitIfNull(
    Platform.environment["CM_ARTIFACT_LINKS"],
    "missing CM Artifacts env variable",
  );

  final json = jsonDecode(artifactsJsonString);
  for (final j in json) {
    final url = j['url'];

    if (url == null) {
      continue;
    }
    print("getting public url for artifact: $url");
    final publicUrl = getPublicUrl(url);
    print("public url data: $publicUrl");
  }
}

Future<String> getPublicUrl(String url) async {
  final codemagicApiToken = exitIfNull(
    Platform.environment["CM_API_TOKEN"],
    "missing CM API Token env variable",
  );

  // expire in 7 days from now
  final expiresDatetime = DateTime.now().millisecondsSinceEpoch ~/ 1000 + const Duration(days: 7).inSeconds;
  final reqUrl = "$url/public-url";
  final response = await http.post(
    Uri.parse(reqUrl),
    headers: {
      "x-auth-token": codemagicApiToken,
      'Content-Type': 'application/json',
    },
    body: '{"expiresAt": $expiresDatetime}',
  );

  return response.body;
}

T exitIfNull<T>(T? o, String errMesg, [exitCode = 1]) {
  if (o == null) {
    print(errMesg);
    exit(exitCode);
  }
  return o;
}
