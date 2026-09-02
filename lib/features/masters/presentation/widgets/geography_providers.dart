import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../api/masters_api.dart';
import 'form_fields.dart';

/// The countries a destination can sit under. Required on create: the server
/// refuses a destination with neither `countryId` nor `country`.
final countriesProvider = FutureProvider.autoDispose<List<DropdownOption>>(
  (ref) => ref.watch(mastersApiProvider).getCountries(),
);

/// The destinations a hotel or a sightseeing entry can sit under.
final destinationsProvider = FutureProvider.autoDispose<List<DropdownOption>>(
  (ref) => ref.watch(mastersApiProvider).getDestinations(),
);

/// The cities already defined under one destination.
///
/// Both catalogs resolve their city *by name* against the destination and
/// refuse a name that is not there, so the forms pick from this rather than
/// accepting free text.
final citiesProvider =
    FutureProvider.autoDispose.family<List<DropdownOption>, int>(
  (ref, destinationId) => ref.watch(mastersApiProvider).getCities(destinationId),
);

/// Flattens an `AsyncValue` into what [SheetPicker] reads.
AsyncValueLike asyncOptions(AsyncValue<List<DropdownOption>> async) =>
    AsyncValueLike(
      options: async.value ?? const [],
      loading: async.isLoading,
      error: async.error,
    );
