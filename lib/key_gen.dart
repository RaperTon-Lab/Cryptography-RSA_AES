import 'package:ninja_prime/ninja_prime.dart';
import 'dart:math';
import './utils.dart';

BigInt euler_totem_var = BigInt.from(1);
//holds euler totient value

class publicKey {
  BigInt first_part_public_key = BigInt.from(1);
  BigInt exponent = BigInt.from(1);

  set setPublicKey(BigInt public_key) {
    first_part_public_key = public_key;
  }

  set setExponent(BigInt var_exponent) {
    exponent = var_exponent;
  }

  BigInt get getPublicKey {
    return first_part_public_key;
  }

  BigInt get getExponent {
    return exponent;
  }
}
//Holds public Key

BigInt RangedRandom(int min, int max) {
  final _random = new Random();
  return BigInt.from(min + _random.nextInt(max - min));
}

publicKey GeneratePublicKey(int bits) {
  final BigInt first_prime = randomPrimeBigInt(bits);
  final BigInt second_prime = randomPrimeBigInt(bits);
  //print(first_prime);
  //print(second_prime);
  BigInt first_part_public_key = first_prime * second_prime;
  euler_totem_var = EulerTotient(first_prime, second_prime);
  var e = new BigInt.from(1);
  while (e < euler_totem_var) {
    if (e.isPrime()) if (e.gcd(euler_totem_var) == BigInt.from(1)) break;
    e = RangedRandom(1000, 100000);
  }
  publicKey public_key = publicKey();
  public_key.setPublicKey = first_part_public_key;
  //print(first_part_public_key);
  public_key.setExponent = e;
  //print(e);
  return public_key;
}

BigInt GeneratePrivateKey(BigInt exponent) {
  BigInt private_key;
  //BigInt a1, a2, a3, b1, b2, b3, d1, d2, d3, k1, k2, k3;
  var a1 = new BigInt.from(1);
  var b1 = new BigInt.from(0);
  var d1 = euler_totem_var;
  var k1 = new BigInt.from(-1);
  var a2 = new BigInt.from(0);
  var b2 = new BigInt.from(1);
  var d2 = exponent;
  var k2 = euler_totem_var ~/ exponent;
  var a3, b3, d3;
  var k3;
  while (d2 != new BigInt.from(1)) {
    a3 = a1 - (a2 * k2);
    b3 = b1 - (b2 * k2);
    d3 = d1 - (d2 * k2);
    k3 = (d2 - new BigInt.from(1)) ~/ d3;
    a1 = a2;
    a2 = a3;
    b1 = b2;
    b2 = b3;
    d1 = d2;
    d2 = d3;
    k2 = k3;
  }
  private_key = b2;
  if (private_key > euler_totem_var)
    private_key = private_key % euler_totem_var;

  if (private_key < BigInt.from(0)) private_key += euler_totem_var;
  return private_key;
}
