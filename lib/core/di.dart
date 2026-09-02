import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/remote/dio_client.dart';
import '../data/remote/token_store.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/booking_repository_impl.dart';
import '../data/repositories/customer_repository_impl.dart';
import '../data/repositories/lead_repository_impl.dart';
import '../data/repositories/operations_repository_impl.dart';
import '../data/repositories/quotation_repository_impl.dart';
import '../data/services/auth_api.dart';
import '../data/services/booking_api.dart';
import '../data/services/calendar_api.dart';
import '../data/services/communication_api.dart';
import '../data/services/company_api.dart';
import '../data/services/customer_api.dart';
import '../data/services/lead_api.dart';
import '../data/services/masters_api.dart';
import '../data/services/notification_api.dart';
import '../data/services/operations_api.dart';
import '../data/services/payment_api.dart';
import '../data/services/quotation_api.dart';
import '../data/services/reports_api.dart';
import '../data/services/search_api.dart';
import '../data/services/task_api.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/booking_repository.dart';
import '../domain/repositories/customer_repository.dart';
import '../domain/repositories/lead_repository.dart';
import '../domain/repositories/operations_repository.dart';
import '../domain/repositories/quotation_repository.dart';
import '../features/auth/providers/auth_controller.dart';

/// Composition root. Everything the app injects is wired here, so tests can
/// override a single provider rather than reaching into constructors.

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

/// The one configured [Dio].
///
/// `onUnauthenticated` is read lazily so this provider does not depend on the
/// auth controller at construction time — that would be a cycle, since the
/// controller depends on the repository, which depends on Dio.
final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    tokens: ref.watch(tokenStoreProvider),
    onUnauthenticated: () async {
      await ref.read(authControllerProvider.notifier).forceSignOut();
    },
  );
});

final authApiProvider = Provider<AuthApi>((ref) => AuthApi(ref.watch(dioProvider)));

final leadApiProvider = Provider<LeadApi>((ref) => LeadApi(ref.watch(dioProvider)));

final customerApiProvider =
    Provider<CustomerApi>((ref) => CustomerApi(ref.watch(dioProvider)));

final bookingApiProvider =
    Provider<BookingApi>((ref) => BookingApi(ref.watch(dioProvider)));

final quotationApiProvider =
    Provider<QuotationApi>((ref) => QuotationApi(ref.watch(dioProvider)));

final operationsApiProvider =
    Provider<OperationsApi>((ref) => OperationsApi(ref.watch(dioProvider)));

/// Calendar and payments have no repository: their payloads are flat lists, so
/// the API class is already the whole data layer for them.
final calendarApiProvider =
    Provider<CalendarApi>((ref) => CalendarApi(ref.watch(dioProvider)));

final paymentApiProvider =
    Provider<PaymentApi>((ref) => PaymentApi(ref.watch(dioProvider)));

final reportsApiProvider =
    Provider<ReportsApi>((ref) => ReportsApi(ref.watch(dioProvider)));

final notificationApiProvider =
    Provider<NotificationApi>((ref) => NotificationApi(ref.watch(dioProvider)));

final mastersApiProvider =
    Provider<MastersApi>((ref) => MastersApi(ref.watch(dioProvider)));

final taskApiProvider =
    Provider<TaskApi>((ref) => TaskApi(ref.watch(dioProvider)));

final companyApiProvider =
    Provider<CompanyApi>((ref) => CompanyApi(ref.watch(dioProvider)));

final communicationApiProvider =
    Provider<CommunicationApi>((ref) => CommunicationApi(ref.watch(dioProvider)));

final searchApiProvider = Provider<SearchApi>((ref) => SearchApi(ref.watch(dioProvider)));

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    ref.watch(authApiProvider),
    ref.watch(tokenStoreProvider),
  ),
);

final leadRepositoryProvider = Provider<LeadRepository>(
  (ref) => LeadRepositoryImpl(ref.watch(leadApiProvider)),
);

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => CustomerRepositoryImpl(ref.watch(customerApiProvider)),
);

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepositoryImpl(ref.watch(bookingApiProvider)),
);

final quotationRepositoryProvider = Provider<QuotationRepository>(
  (ref) => QuotationRepositoryImpl(ref.watch(quotationApiProvider)),
);

final operationsRepositoryProvider = Provider<OperationsRepository>(
  (ref) => OperationsRepositoryImpl(ref.watch(operationsApiProvider)),
);
