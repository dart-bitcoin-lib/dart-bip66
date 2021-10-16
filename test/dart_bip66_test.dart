import 'dart:typed_data';

import 'package:convert/convert.dart';
import 'package:dart_bip66/dart_bip66.dart';
import 'package:test/test.dart';

import 'fixtures.dart';

void main() {
  if (fixtures.containsKey(FixtureEnum.valid)) {
    for (Fixture fixture in fixtures[FixtureEnum.valid]!) {
      Uint8List derBuffer = fixture.derBuffer!;
      test('check: returns true for ${fixture.der}', () {
        expect(DER.check(derBuffer), isTrue);
      });
      test('decode: ${fixture.der}', () {
        var signature = DER.decode(derBuffer);
        expect(hex.encode(signature.r), equals(fixture.r));
        expect(hex.encode(signature.s), equals(fixture.s));
      });
      test('encode: ${fixture.r}, ${fixture.s}', () {
        Uint8List r = Uint8List.fromList(hex.decode(fixture.r!));
        Uint8List s = Uint8List.fromList(hex.decode(fixture.s!));
        DER der = DER(r: r, s: s);
        expect(der.toString(), equals(fixture.der));
      });
    }
  }
  if (fixtures.containsKey(FixtureEnum.invalidDecode)) {
    for (Fixture fixture in fixtures[FixtureEnum.invalidDecode]!) {
      Uint8List derBuffer = fixture.derBuffer!;
      test('check: returns false for ${fixture.der} (${fixture.exception})',
          () {
        expect(DER.check(derBuffer), isFalse);
      });
      test('throws "Exception: ${fixture.exception}" for ${fixture.der}', () {
        DER? signature;
        try {
          signature = DER.decode(derBuffer);
        } catch (e) {
          expect((e as Exception).toString(), equals(fixture.exception));
        }
        expect(signature, isNull);
      });
    }
  }
  if (fixtures.containsKey(FixtureEnum.invalidEncode)) {
    for (Fixture fixture in fixtures[FixtureEnum.invalidEncode]!) {
      test(
          'throws "Exception: ${fixture.exception}" for ${fixture.r}, ${fixture.s}',
          () {
        Uint8List r = Uint8List.fromList(hex.decode(fixture.r!));
        Uint8List s = Uint8List.fromList(hex.decode(fixture.s!));
        Uint8List? buff;
        try {
          buff = DER(r: r, s: s).encode();
        } catch (e) {
          expect((e as Exception).toString(), equals(fixture.exception));
        }
        expect(buff, isNull);
      });
    }
  }
}
