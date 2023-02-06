#!/usr/bin/env dart
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypton/crypton.dart';

void main(List<String> args) {
  // expect signing key to be in this env var as a base64 encoded string
  final privateKeyString = Platform.environment["PRIVATE_SIGN_KEY"];
  if (privateKeyString == null) {
    print("missing private key");
    return;
  }
  final privateKey = RSAPrivateKey.fromString(privateKeyString);

  final scriptFile = File(args[0]);
  final toSign = scriptFile.readAsBytesSync();

  final signature = privateKey.createSHA256Signature(toSign);

  final signatureFile = File("signature");
  // serialise signature to file as Base64
  signatureFile.writeAsStringSync(base64.encode(signature));

  // sanity check signing process worked as expected
  final publicKeyFile = File("assets/public_key");
  final publicKeyString = publicKeyFile.readAsStringSync();
  final publicKey = RSAPublicKey.fromString(publicKeyString);

  final signatureFromFile = base64.decode(signatureFile.readAsStringSync());
  final verified = publicKey.verifySHA256Signature(toSign, signatureFromFile);

  if (verified) {
    print('signature for $scriptFile verified!');
  } else {
    print('signature for $scriptFile could not be verified!');
  }
}
