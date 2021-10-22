import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_bip66/src/models/der_model.dart';

/// The canonical instance of [DerEncoder].
const derEncoder = DerEncoder();

/// DER signature encoder
class DerEncoder extends Converter<DER, Uint8List> {
  const DerEncoder();

  @override
  Uint8List convert(DER input) {
    int lenR = input.r.length;
    int lenS = input.s.length;
    if (lenR == 0) throw Exception('R length is zero');
    if (lenS == 0) throw Exception('S length is zero');
    if (lenR > 33) throw Exception('R length is too long');
    if (lenS > 33) throw Exception('S length is too long');
    if ((input.r[0] & 0x80) != 0) throw Exception('R value is negative');
    if ((input.s[0] & 0x80) != 0) throw Exception('S value is negative');
    if (lenR > 1 && (input.r[0] == 0x00) && !((input.r[1] & 0x80) != 0)) {
      throw Exception('R value excessively padded');
    }
    if (lenS > 1 && (input.s[0] == 0x00) && !((input.s[1] & 0x80) != 0)) {
      throw Exception('S value excessively padded');
    }

    Uint8List signature = Uint8List(6 + lenR + lenS);

    // 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
    signature[0] = 0x30;
    signature[1] = signature.length - 2;
    signature[2] = 0x02;
    signature[3] = input.r.length;
    signature.setAll(4, input.r);
    signature[4 + lenR] = 0x02;
    signature[5 + lenR] = input.s.length;
    signature.setAll(6 + lenR, input.s);

    return signature;
  }
}
