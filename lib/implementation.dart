import 'dart:io';
import './rsa.dart';
import './utils.dart';
import './key_gen.dart';
// additional imports will be needed

publicKey public_key = publicKey();
BigInt private_key = BigInt.from(0);

void GenerateKeys() {
  public_key = GeneratePublicKey(2046);
  private_key = GeneratePrivateKey(public_key.getExponent);
}

String Encrypt(String input) {
  BigInt data = stringToBig(input);
  //print(data);
  BigInt encryptedData = EncryptData(data, public_key);
  print(encryptedData);
  String str = encryptedData.toRadixString(16);
  print("String $str");
  return str;
}

String Decrypt(String input) {
  var inputData = '0x';
  inputData += input;
  var data = BigInt.parse(inputData);
  //print(data);
  BigInt decryptedData =
      DecryptData(data, private_key, public_key.first_part_public_key);
  print(decryptedData);
  String str = bigToString(decryptedData);

  print("String $str");
  return str;
}
