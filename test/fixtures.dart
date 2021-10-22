import 'dart:typed_data';

import 'package:convert/convert.dart';

enum FixtureEnum { valid, invalidEncode, invalidDecode }

class Fixture {
  String? der;
  Uint8List? get derBuffer {
    return Uint8List.fromList(hex.decode(der!));
  }

  String? r;
  String? s;
  String? exception;

  Fixture({this.der, this.r, this.s, this.exception});
}

Map<FixtureEnum, List<Fixture>> fixtures = {
  FixtureEnum.valid: [
    Fixture(
        der:
            "3044022029db2d5f4e1dcc04e19266cce3cb135865784c62ab653b307f0e0bb744f5c2aa022000a97f5826912cac8b44d9f577a26f169a2f8db781f2ddb7de2bc886e93b6844",
        r: "29db2d5f4e1dcc04e19266cce3cb135865784c62ab653b307f0e0bb744f5c2aa",
        s: "00a97f5826912cac8b44d9f577a26f169a2f8db781f2ddb7de2bc886e93b6844"),
    Fixture(
        der:
            "304302201ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777021f29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1",
        r: "1ea1fdff81b3a271659df4aad19bc4ef83def389131a36358fe64b245632e777",
        s: "29e164658be9ce810921bf81d6b86694785a79ea1e52dbfa5105148d1f0bc1"),
    Fixture(
        der:
            "304402201b19519b38ca1e6813cd25649ad36be8bc6a6f2ad9758089c429acd9ce0b572f02203bf32193c8a3a3de1f847cd6e6eebf43c96df1ffa4d7fe920f8f71708920c65f",
        r: "1b19519b38ca1e6813cd25649ad36be8bc6a6f2ad9758089c429acd9ce0b572f",
        s: "3bf32193c8a3a3de1f847cd6e6eebf43c96df1ffa4d7fe920f8f71708920c65f"),
    Fixture(
        der:
            "3044022000c8da1836747d05a6a3d2c395825edce827147d15909e66939a5037d5916e6f022017823c2da62f539d7f8e1e186eaea7a401ab3c077dcfc44aeaf3e13fac99bdbc",
        r: "00c8da1836747d05a6a3d2c395825edce827147d15909e66939a5037d5916e6f",
        s: "17823c2da62f539d7f8e1e186eaea7a401ab3c077dcfc44aeaf3e13fac99bdbc"),
    Fixture(
        der:
            "3042021e2ff2609c8dc0392d3731a2c6312841e09c76f10b83e2b52604dc84886dd502200090ac80e787c063618192bc04758e6666d0179c377fb2f3d6105d58000f33ac",
        r: "2ff2609c8dc0392d3731a2c6312841e09c76f10b83e2b52604dc84886dd5",
        s: "0090ac80e787c063618192bc04758e6666d0179c377fb2f3d6105d58000f33ac"),
    Fixture(
        der:
            "3041021d00feb1a12c27e5fe261acc64c0923add082573883e0800d8e4080fa9bb02202e7aeb97f4046ea3be60d2896a19c8dc269ab5eb2de968912cd52a076a0a42e9",
        r: "00feb1a12c27e5fe261acc64c0923add082573883e0800d8e4080fa9bb",
        s: "2e7aeb97f4046ea3be60d2896a19c8dc269ab5eb2de968912cd52a076a0a42e9"),
    Fixture(
        der:
            "3042021d00feb1a12c27e5fe261acc64c0923add082573883e0800d8e4080fa9bb0221008aeb97f4046ea3be60d2896a19c8dc269ab5eb2de968912cd52a076a0a42e925",
        r: "00feb1a12c27e5fe261acc64c0923add082573883e0800d8e4080fa9bb",
        s: "008aeb97f4046ea3be60d2896a19c8dc269ab5eb2de968912cd52a076a0a42e925"),
    Fixture(
        der:
            "303e021d00c1d545da2e4edfbc65e9267d3c0a6fdda41793d0fd945f15acbcf0dd021d009acffda3ca5e7c349c35ba606f0a8f1ec7815b653b51695ca9ee69a6",
        r: "00c1d545da2e4edfbc65e9267d3c0a6fdda41793d0fd945f15acbcf0dd",
        s: "009acffda3ca5e7c349c35ba606f0a8f1ec7815b653b51695ca9ee69a6"),
    Fixture(der: "3006020100020100", r: "00", s: "00")
  ],
  FixtureEnum.invalidEncode: [
    Fixture(
        exception: "Exception: R length is zero",
        r: "",
        s: "0080000000000000000000000000000000000000000000000000000000000000"),
    Fixture(
        exception: "Exception: S length is zero",
        r: "0080000000000000000000000000000000000000000000000000000000000000",
        s: ""),
    Fixture(exception: "Exception: R value is negative", r: "80", s: "7f"),
    Fixture(exception: "Exception: S value is negative", r: "7f", s: "80"),
    Fixture(
        exception: "Exception: R value excessively padded",
        r: "0010000000000000000000000000000000000000000000000000000000000000",
        s: "0080000000000000000000000000000000000000000000000000000000000000"),
    Fixture(
        exception: "Exception: S value excessively padded",
        r: "0080000000000000000000000000000000000000000000000000000000000000",
        s: "0010000000000000000000000000000000000000000000000000000000000000"),
    Fixture(
        exception: "Exception: R length is too long",
        r: "00800000000000000000000000000000000000000000000000000000000000000000",
        s: "008000000000000000000000000000000000000000000000000000000000000000"),
    Fixture(
        exception: "Exception: S length is too long",
        r: "008000000000000000000000000000000000000000000000000000000000000000",
        s: "00800000000000000000000000000000000000000000000000000000000000000000")
  ],
  FixtureEnum.invalidDecode: [
    Fixture(
        exception: "Exception: DER sequence length is too short",
        der: "ffffffffffffff"),
    Fixture(
        exception: "Exception: DER sequence length is too long",
        der:
            "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"),
    Fixture(
        exception: "Exception: Expected DER sequence",
        der: "00ffff0400ffffff020400ffffff"),
    Fixture(
        exception: "Exception: DER sequence length is invalid",
        der: "30ff020400ffffff020400ffffff"),
    Fixture(
        exception: "Exception: DER sequence length is invalid",
        der: "300c030400ffffff030400ffffff0000"),
    Fixture(
        exception: "Exception: Expected DER integer",
        der: "300cff0400ffffff020400ffffff"),
    Fixture(
        exception: "Exception: Expected DER integer (2)",
        der: "300c020200ffffff020400ffffff"),
    Fixture(
        exception: "Exception: R length is zero", der: "30080200020400ffffff"),
    Fixture(
        exception: "Exception: S length is zero", der: "3008020400ffffff0200"),
    Fixture(
        exception: "Exception: R length is too long",
        der: "300c02dd00ffffff020400ffffff"),
    Fixture(
        exception: "Exception: S length is invalid",
        der: "300c020400ffffff02dd00ffffff"),
    Fixture(
        exception: "Exception: R value is negative",
        der: "300c020480000000020400ffffff"),
    Fixture(
        exception: "Exception: S value is negative",
        der: "300c020400ffffff020480000000"),
    Fixture(
        exception: "Exception: R value excessively padded",
        der: "300c02040000ffff020400ffffff"),
    Fixture(
        exception: "Exception: S value excessively padded",
        der: "300c020400ffffff02040000ffff")
  ]
};
