import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_bip66/src/converters/api.dart';
import 'package:dart_bip66/src/models/der_model.dart';

export 'package:dart_bip66/src/converters/api.dart' show derEncoder, derDecoder;
export 'package:dart_bip66/src/models/der_model.dart';

const der = DERCodec();

/// Strict DER signature encoding/decoding codec.
/// Reference https://github.com/bitcoin/bips/blob/master/bip-0066.mediawiki
/// Format: 0x30 [total-length] 0x02 [R-length] [R] 0x02 [S-length] [S]
/// NOTE: SIGHASH byte ignored AND restricted, truncate before use
class DERCodec extends Codec<DER, Uint8List> {
  const DERCodec();

  /// Signature Check
  bool check(Uint8List buffer) {
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

  @override
  DerDecoder get decoder => derDecoder;

  @override
  DerEncoder get encoder => derEncoder;
}
