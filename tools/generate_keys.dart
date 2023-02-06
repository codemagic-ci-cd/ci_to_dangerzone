#!/bin/env dart

// ignore_for_file: avoid_print
import 'dart:io';

import 'package:crypton/crypton.dart';

void main(List<String> args) {
  final rsaKeypair = RSAKeypair.fromRandom();

  final privateKeyString = rsaKeypair.privateKey.toString();
  final publicKeyString = rsaKeypair.publicKey.toString();

  File privateKeyFile = File("private_key");
  File publicKeyFile = File("public_key");

  privateKeyFile.writeAsStringSync(privateKeyString);
  publicKeyFile.writeAsStringSync(publicKeyString);

  print("generated key pair files");
}
