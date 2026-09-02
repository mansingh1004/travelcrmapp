import '../../core/errors/failure.dart';
import '../../domain/entities/customer.dart';
import '../../domain/repositories/customer_repository.dart';
import '../mappers/customer_mapper.dart';
import '../services/customer_api.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl(this._api);

  final CustomerApi _api;

  @override
  Future<CustomerPage> getCustomers({
    int page = 0,
    int size = 20,
    String sortBy = 'createdAt',
    String sortDir = 'desc',
    CustomerFilter filter = CustomerFilter.none,
  }) async {
    final envelope = await _api.getCustomers(
      page: page,
      size: size,
      sortBy: sortBy,
      sortDir: sortDir,
      q: filter.search,
      status: filter.status?.wire,
      type: filter.type?.wire,
      tier: filter.tier?.wire,
    );

    return CustomerPage(
      // A row without a publicId cannot be opened, so drop it rather than
      // render a card that navigates nowhere.
      customers: envelope.content
          .map(CustomerMapper.toEntity)
          .where((c) => c.id.isNotEmpty)
          .toList(growable: false),
      pageNumber: envelope.pageNumber,
      totalElements: envelope.totalElements,
      hasMore: envelope.hasMore,
    );
  }

  @override
  Future<Customer> getCustomer(String publicId) async =>
      CustomerMapper.toEntity(await _api.getCustomer(publicId));

  @override
  Future<CustomerSummary> getSummary(String publicId) async =>
      CustomerMapper.toSummary(await _api.getSummary(publicId));

  @override
  Future<CustomerStats?> getStats() async {
    try {
      return CustomerMapper.toStats(await _api.getStats());
    } on PermissionFailure {
      // The stats endpoint is CRM_FULL-only; a sub-agent simply sees no tiles.
      return null;
    }
  }
}
