import '../entities/customer.dart';
import '../entities/customer_enums.dart';

/// Filters `GET /api/customers` applies in the database.
class CustomerFilter {
  const CustomerFilter({this.search, this.status, this.type, this.tier});

  final String? search;
  final CustomerStatus? status;
  final CustomerType? type;
  final LoyaltyTier? tier;

  static const none = CustomerFilter();

  int get appliedCount => [
        search?.trim().isNotEmpty ?? false,
        status != null,
        type != null,
        tier != null,
      ].where((applied) => applied).length;

  CustomerFilter copyWith({
    Object? search = _unset,
    Object? status = _unset,
    Object? type = _unset,
    Object? tier = _unset,
  }) =>
      CustomerFilter(
        search: search == _unset ? this.search : search as String?,
        status: status == _unset ? this.status : status as CustomerStatus?,
        type: type == _unset ? this.type : type as CustomerType?,
        tier: tier == _unset ? this.tier : tier as LoyaltyTier?,
      );

  static const _unset = Object();
}

/// One page of customers plus paging state.
class CustomerPage {
  const CustomerPage({
    required this.customers,
    required this.pageNumber,
    required this.totalElements,
    required this.hasMore,
  });

  final List<Customer> customers;
  final int pageNumber;
  final int totalElements;
  final bool hasMore;

  static const empty =
      CustomerPage(customers: [], pageNumber: 0, totalElements: 0, hasMore: false);
}

abstract interface class CustomerRepository {
  Future<CustomerPage> getCustomers({
    int page,
    int size,
    String sortBy,
    String sortDir,
    CustomerFilter filter,
  });

  Future<Customer> getCustomer(String publicId);

  /// The customer-360 header.
  Future<CustomerSummary> getSummary(String publicId);

  /// Tenant-wide aggregates. Returns `null` when the caller lacks CRM_FULL —
  /// a permission gap is not an error to show the user.
  Future<CustomerStats?> getStats();
}
