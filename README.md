# bip66

Strict DER signature encoding/decoding.

See [bip66](https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki).

- This module **works only with [two's complement](https://en.wikipedia.org/wiki/Two's_complement) numbers**.
- BIP66 doesn't check that `r` or `s` are fully valid.
    - `check`/`decode` doesn't check that `r` or `s` great than 33 bytes or that this number represent valid point on elliptic curve.
    - `encode` doesn't check that `r`/`s` represent valid point on elliptic curve.

## Example

``` dart
import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_bip66/dart_bip66.dart';

void main() {
  Uint8List r = Uint8List.fromList(hex.decode(
      '1ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777'));
  Uint8List s = Uint8List.fromList(hex.decode(
      '29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1'));
  // => 304302201ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777021f29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1
  print(der.encode(DER(r: r, s: s)));
  // => [48, 67, 2, 32, 30, 161, 253, 255, 129, 179, 162, 113, 101, 157, 244, 170, 209, 155, 196, 239, 131, 222, 243, 137, 19, 26, 54, 53, 143, 230, 75, 36, 86, 50, 231, 119, 2, 31, 41, 225, 100, 101, 139, 233, 206, 129, 9, 33, 191, 129, 214, 184, 102, 148, 120, 90, 121, 234, 30, 82, 219, 250, 81, 5, 20, 141, 31, 11, 193]

  Uint8List signature = Uint8List.fromList(hex.decode(
      '304302201ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777021f29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1'));

  DER decodedSignature = der.decode(signature);
  print(decodedSignature);
  // => 304302201ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777021f29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1
  print(der.encode(decodedSignature));
  // => [48, 67, 2, 32, 30, 161, 253, 255, 129, 179, 162, 113, 101, 157, 244, 170, 209, 155, 196, 239, 131, 222, 243, 137, 19, 26, 54, 53, 143, 230, 75, 36, 86, 50, 231, 119, 2, 31, 41, 225, 100, 101, 139, 233, 206, 129, 9, 33, 191, 129, 214, 184, 102, 148, 120, 90, 121, 234, 30, 82, 219, 250, 81, 5, 20, 141, 31, 11, 193]
}
```

## LICENSE [MIT](LICENSE)