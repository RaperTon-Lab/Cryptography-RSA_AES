import './key_gen.dart';

BigInt EncryptData(BigInt data, publicKey public_key) {
  BigInt encrypted_data =
      data.modPow(public_key.getExponent, public_key.getPublicKey);
  return encrypted_data;
}

BigInt DecryptData(BigInt encrypt_data, BigInt private_key, BigInt public_key) {
  BigInt decrypted_data = encrypt_data.modPow(private_key, public_key);
  return decrypted_data;
}