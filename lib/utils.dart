import 'dart:async'; // you will need to add this import in order to use Future's
//import 'dart:typed_data';
//import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

BigInt EulerTotient(BigInt firstPrime, BigInt secondPrime) {
  var one = BigInt.from(1);
  return (firstPrime - one) * (secondPrime - one);
}

String bigToString(var val) {
  String res = "";
  while (val != BigInt.from(1)) {
    res += String.fromCharCode((val % BigInt.from(1000)).toInt());
    val = (val ~/ BigInt.from(1000));
  }
  res = String.fromCharCodes(res.codeUnits.reversed);
  //print(res);
  return res;
}

BigInt stringToBig(String str) {
  var n = str.length;
  var val = BigInt.from(1);
  for (int i = 0; i < n; ++i) {
    val = val * BigInt.from(1000) + BigInt.from(str.codeUnitAt(i));
  }
  //print(val);
  return val;
}
