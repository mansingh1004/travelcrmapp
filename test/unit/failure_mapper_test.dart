import 'package:crmapp/core/errors/failure.dart';
import 'package:crmapp/data/remote/failure_mapper.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

DioException _http(int status, Object? body) {
  final options = RequestOptions(path: '/api/leads');
  return DioException(
    requestOptions: options,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: options,
      statusCode: status,
      data: body,
    ),
  );
}

void main() {
  group('FailureMapper', () {
    test('maps the backend ErrorResponse shape', () {
      final failure = FailureMapper.from(
        _http(409, const {
          'status': 409,
          'error': 'CONFLICT',
          'message': 'Lead already exists with phone : 9822041155',
          'timestamp': '2026-08-29T12:00:00',
        }),
      );

      expect(failure, isA<ConflictFailure>());
      expect(failure.message, 'Lead already exists with phone : 9822041155');
    });

    test('unpacks the stringified Java map in a VALIDATION_ERROR', () {
      // The backend puts `Map.toString()` into `message` rather than returning
      // structured field errors.
      final failure = FailureMapper.from(
        _http(400, const {
          'status': 400,
          'error': 'VALIDATION_ERROR',
          'message': 'Validation failed: {phone=Enter a valid 10-digit Indian '
              'mobile number, email=Enter a valid email address}',
        }),
      ) as ValidationFailure;

      expect(failure.fieldErrors['phone'], 'Enter a valid 10-digit Indian mobile number');
      expect(failure.fieldErrors['email'], 'Enter a valid email address');
      // The user sees a real sentence, not the raw dump.
      expect(failure.message, isNot(contains('{')));
    });

    test('401 becomes AuthFailure', () {
      final failure = FailureMapper.from(
        _http(401, const {'error': 'UNAUTHORIZED', 'message': 'Invalid email or password'}),
      );
      expect(failure, isA<AuthFailure>());
    });

    test('500 is a ServerFailure by default', () {
      expect(FailureMapper.from(_http(500, null)), isA<ServerFailure>());
    });

    test('500 becomes NotFound when the caller opts in', () {
      // GET /api/leads/search returns 500 on a miss, because the lead-package
      // ResourceNotFoundException is not registered in the exception handler.
      final failure = FailureMapper.from(_http(500, null), treat500AsNotFound: true);
      expect(failure, isA<NotFoundFailure>());
    });

    test('reads a text/plain error body', () {
      // Every /api/auth/* endpoint replies in text/plain.
      final failure = FailureMapper.from(_http(400, 'Email already registered: a@b.com'));
      expect(failure.message, 'Email already registered: a@b.com');
    });

    test('maps transport errors without a response', () {
      final options = RequestOptions(path: '/api/leads');
      expect(
        FailureMapper.from(
          DioException(requestOptions: options, type: DioExceptionType.connectionError),
        ),
        isA<NetworkFailure>(),
      );
      expect(
        FailureMapper.from(
          DioException(requestOptions: options, type: DioExceptionType.receiveTimeout),
        ),
        isA<TimeoutFailure>(),
      );
      // The auth interceptor cancels when there is no usable token.
      expect(
        FailureMapper.from(
          DioException(requestOptions: options, type: DioExceptionType.cancel),
        ),
        isA<AuthFailure>(),
      );
    });
  });
}
