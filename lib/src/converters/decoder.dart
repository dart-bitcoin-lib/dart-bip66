import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_bip66/src/models/der_model.dart';

/// The canonical instance of [DerDecoder].
const derDecoder = DerDecoder();

/// DER signature decoder
class DerDecoder extends Converter<Uint8List, DER> {
  const DerDecoder();

  @override
  DER convert(Uint8List input) {
    if (input.length < 8) throw Exception('DER sequence length is too short');
    if (input.length > 72) throw Exception('DER sequence length is too long');
    if (input[0] != 0x30) throw Exception('Expected DER sequence');
    if (input[1] != input.length - 2) {
      throw Exception('DER sequence length is invalid');
    }
    if (input[2] != 0x02) throw Exception('Expected DER integer');

    var lenR = input[3];
    if (lenR == 0) throw Exception('R length is zero');
    if (5 + lenR >= input.length) throw Exception('R length is too long');
    if (input[4 + lenR] != 0x02) throw Exception('Expected DER integer (2)');

    var lenS = input[5 + lenR];
    if (lenS == 0) throw Exception('S length is zero');
    if ((6 + lenR + lenS) != input.length) {
      throw Exception('S length is invalid');
    }

    if ((input[4] & 0x80) != 0) throw Exception('R value is negative');
    if (lenR > 1 && (input[4] == 0x00) && (input[5] & 0x80) == 0) {
      throw Exception('R value excessively padded');
    }

    if ((input[lenR + 6] & 0x80) != 0) throw Exception('S value is negative');
    if (lenS > 1 &&
        (input[lenR + 6] == 0x00) &&
        (input[lenR + 7] & 0x80) == 0) {
      throw Exception('S value excessively padded');
    }

    // non-BIP66 - extract R, S values
    return DER(r: input.sublist(4, 4 + lenR), s: input.sublist(6 + lenR));
  }
}
