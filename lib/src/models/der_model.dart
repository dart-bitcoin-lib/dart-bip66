import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_bip66/dart_bip66.dart';

/// Der Model
class DER {
  Uint8List r;
  Uint8List s;

  DER({required this.r, required this.s});

  @override
  String toString() {
    return hex.encode(der.encode(this));
  }
}
