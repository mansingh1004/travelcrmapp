import 'package:crmapp/core/formatters/app_date.dart';
import 'package:crmapp/core/formatters/inr.dart';
import 'package:crmapp/core/formatters/phone.dart';
import 'package:crmapp/core/utils/jwt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Inr', () {
    test('groups in lakhs and crores, not thousands', () {
      expect(Inr.format(1850000), '₹18,50,000');
      expect(Inr.format(96000), '₹96,000');
      expect(Inr.format(12345678), '₹1,23,45,678');
    });

    test('compact form uses L and Cr', () {
      expect(Inr.compact(1850000), '₹18.5L');
      expect(Inr.compact(12500000), '₹1.25Cr');
      expect(Inr.compact(85000), '₹85,000');
    });

    test('null renders as an em dash, never as zero', () {
      expect(Inr.format(null), '—');
      expect(Inr.compact(null), '—');
    });
  });

  group('AppDate', () {
    test('formats as dd MMM yyyy and 12-hour time', () {
      final d = DateTime(2026, 9, 12, 13, 30);
      expect(AppDate.display(d), '12 Sep 2026');
      expect(AppDate.time(d), '1:30 PM');
      expect(AppDate.toWire(d), '2026-09-12');
    });

    test('parses a backend LocalDateTime as local, not UTC', () {
      final parsed = AppDate.parseDateTime('2026-08-20T11:30:00.123');
      expect(parsed, DateTime(2026, 8, 20, 11, 30, 0, 123));
      expect(parsed!.isUtc, isFalse);
    });

    test('returns null rather than throwing on bad input', () {
      expect(AppDate.parseDate('not-a-date'), isNull);
      expect(AppDate.parseDate(''), isNull);
      expect(AppDate.parseDate(null), isNull);
    });
  });

  group('Phone', () {
    test('normalises the common Indian input forms to 10 digits', () {
      expect(Phone.normalise('+91 98220 41155'), '9822041155');
      expect(Phone.normalise('09822041155'), '9822041155');
      expect(Phone.normalise('98220-41155'), '9822041155');
      expect(Phone.normalise('9822041155'), '9822041155');
    });

    test('validates against the server regex ^[6-9]\\d{9}\$', () {
      expect(Phone.isValid('9822041155'), isTrue);
      expect(Phone.isValid('+91 98220 41155'), isTrue);
      // Leading digit below 6 is rejected server-side.
      expect(Phone.isValid('5822041155'), isFalse);
      expect(Phone.isValid('982204115'), isFalse);
    });

    test('builds tel and wa.me targets', () {
      expect(Phone.dialUri('9822041155'), 'tel:+919822041155');
      expect(Phone.whatsAppUri('9822041155'), 'https://wa.me/919822041155');
      expect(Phone.display('9822041155'), '+91 98220 41155');
    });
  });

  group('Jwt', () {
    // HS256 token, payload {"sub":"man@agency.in","iat":1700000000,
    // "exp":1700086400}. Signature is not checked client-side.
    const token = 'eyJhbGciOiJIUzI1NiJ9.'
        'eyJzdWIiOiJtYW5AYWdlbmN5LmluIiwiaWF0IjoxNzAwMDAwMDAwLCJleHAiOjE3MDAwODY0MDB9.'
        'c2lnbmF0dXJl';

    test('reads the sub claim, which is the only identity available', () {
      expect(Jwt.subject(token), 'man@agency.in');
    });

    test('reads exp so expiry can be detected without the server', () {
      // The backend never returns 401 for a stale token, so this check is the
      // only thing standing between the user and a silently dead session.
      expect(Jwt.expiry(token), DateTime.fromMillisecondsSinceEpoch(1700086400 * 1000));
      expect(Jwt.isExpired(token), isTrue, reason: 'exp is in the past');
    });

    test('treats a malformed token as expired rather than throwing', () {
      expect(Jwt.payload('not-a-jwt'), isNull);
      expect(Jwt.isExpired('not-a-jwt'), isTrue);
      expect(Jwt.isExpired(null), isTrue);
      expect(Jwt.isValid('a.b.c'), isFalse);
    });
  });
}
