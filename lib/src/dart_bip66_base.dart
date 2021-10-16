import 'dart:typed_data';

import 'package:convert/convert.dart';

/// Strict DER signature encoding/decoding.
/// Reference https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki
/// Format: 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
/// NOTE: SIGHASH byte ignored AND restricted, truncate before use
class DER {
  Uint8List r;
  Uint8List s;

  DER({required this.r, required this.s});

  factory DER.decode(Uint8List buffer) {
    if (buffer.length < 8) throw Exception('DER sequence length is too short');
    if (buffer.length > 72) throw Exception('DER sequence length is too long');
    if (buffer[0] != 0x30) throw Exception('Expected DER sequence');
    if (buffer[1] != buffer.length - 2) {
      throw Exception('DER sequence length is invalid');
    }
    if (buffer[2] != 0x02) throw Exception('Expected DER integer');

    var lenR = buffer[3];
    if (lenR == 0) throw Exception('R length is zero');
    if (5 + lenR >= buffer.length) throw Exception('R length is too long');
    if (buffer[4 + lenR] != 0x02) throw Exception('Expected DER integer (2)');

    var lenS = buffer[5 + lenR];
    if (lenS == 0) throw Exception('S length is zero');
    if ((6 + lenR + lenS) != buffer.length) {
      throw Exception('S length is invalid');
    }

    if ((buffer[4] & 0x80) != 0) throw Exception('R value is negative');
    if (lenR > 1 && (buffer[4] == 0x00) && (buffer[5] & 0x80) == 0) {
      throw Exception('R value excessively padded');
    }

    if ((buffer[lenR + 6] & 0x80) != 0) throw Exception('S value is negative');
    if (lenS > 1 && (buffer[lenR + 6] == 0x00) && (buffer[lenR + 7] & 0x80) == 0) {
      throw Exception('S value excessively padded');
    }

    // non-BIP66 - extract R, S values
    return DER(r: buffer.sublist(4, 4 + lenR), s: buffer.sublist(6 + lenR));
  }

  static bool check(Uint8List buffer) {
    if (buffer.length < 8) return false;
    if (buffer.length > 72) return false;
    if (buffer[0] != 0x30) return false;
    if (buffer[1] != buffer.length - 2) return false;
    if (buffer[2] != 0x02) return false;

    var lenR = buffer[3];
    if (lenR == 0) return false;
    if (5 + lenR >= buffer.length) return false;
    if (buffer[4 + lenR] != 0x02) return false;

    var lenS = buffer[5 + lenR];
    if (lenS == 0) return false;
    if ((6 + lenR + lenS) != buffer.length) return false;

    if ((buffer[4] & 0x80) != 0) return false;
    if (lenR > 1 && (buffer[4] == 0x00) && !((buffer[5] & 0x80) != 0)) {
      return false;
    }

    if ((buffer[lenR + 6] & 0x80) != 0) return false;
    if (lenS > 1 &&
        (buffer[lenR + 6] == 0x00) &&
        !((buffer[lenR + 7] & 0x80) != 0)) return false;
    return true;
  }

  Uint8List encode() {
    int lenR = r.length;
    int lenS = s.length;
    if (lenR == 0) throw Exception('R length is zero');
    if (lenS == 0) throw Exception('S length is zero');
    if (lenR > 33) throw Exception('R length is too long');
    if (lenS > 33) throw Exception('S length is too long');
    if ((r[0] & 0x80) != 0) throw Exception('R value is negative');
    if ((s[0] & 0x80) != 0) throw Exception('S value is negative');
    if (lenR > 1 && (r[0] == 0x00) && !((r[1] & 0x80) != 0)) {
      throw Exception('R value excessively padded');
    }
    if (lenS > 1 && (s[0] == 0x00) && !((s[1] & 0x80) != 0)) {
      throw Exception('S value excessively padded');
    }

    Uint8List signature = Uint8List(6 + lenR + lenS);

    // 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
    signature[0] = 0x30;
    signature[1] = signature.length - 2;
    signature[2] = 0x02;
    signature[3] = r.length;
    signature.setAll(4, r);
    signature[4 + lenR] = 0x02;
    signature[5 + lenR] = s.length;
    signature.setAll(6 + lenR, s);

    return signature;
  }

  @override
  String toString() {
    return hex.encode(encode());
  }
}
