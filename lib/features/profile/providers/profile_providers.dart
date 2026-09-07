import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di.dart';
import '../../../data/services/company_api.dart';

/// The signed-in user's own record — `GET /api/me`.
final meProfileProvider = FutureProvider.autoDispose<MeProfile>(
  (ref) => ref.watch(companyApiProvider).getProfile(),
);

/// The agency the signed-in user belongs to.
///
/// Read from more than one feature — profile and settings show it, and a
/// quotation stamps the agency's details onto the document it renders — which
/// is why it lives here rather than beside any one of those screens.
final companyProvider = FutureProvider.autoDispose<Company>(
  (ref) => ref.watch(companyApiProvider).getCompany(),
);
