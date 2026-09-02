import '../../core/formatters/app_date.dart';
import '../../domain/entities/customer.dart';
import '../../domain/entities/customer_enums.dart';
import '../dto/customer_dto.dart';

/// DTO → entity conversion for the customer module. Lenient throughout: an
/// unknown enum or unparseable date yields null on that field rather than
/// throwing, so one bad row cannot blank a page.
abstract final class CustomerMapper {
  static Customer toEntity(CustomerDto dto) => Customer(
        id: dto.id ?? '',
        code: _blankToNull(dto.customerId),
        name: dto.name?.trim() ?? '',
        phone: dto.phone ?? '',
        email: _blankToNull(dto.email),
        alternatePhone: _blankToNull(dto.alternatePhone),
        type: CustomerType.tryParse(dto.type),
        tier: LoyaltyTier.tryParse(dto.tier),
        status: CustomerStatus.tryParse(dto.status),
        commPref: CommunicationPreference.tryParse(dto.commPref),
        city: _blankToNull(dto.city),
        state: _blankToNull(dto.state),
        address: _blankToNull(dto.address),
        pincode: _blankToNull(dto.pincode),
        country: _blankToNull(dto.country),
        gstin: _blankToNull(dto.gstin),
        legalName: _blankToNull(dto.legalName),
        birthday: AppDate.parseDate(dto.birthday),
        anniversary: AppDate.parseDate(dto.anniversary),
        passportNo: _blankToNull(dto.passportNo),
        passportExpiry: AppDate.parseDate(dto.passportExpiry),
        panNo: _blankToNull(dto.panNo),
        nationality: _blankToNull(dto.nationality),
        notes: _blankToNull(dto.notes),
        bookingCount: dto.bookings ?? 0,
        spent: dto.spent?.toDouble(),
        lastBooking: AppDate.parseDate(dto.lastBooking),
        createdAt: AppDate.parseDateTime(dto.createdAt),
      );

  static CustomerSummary toSummary(CustomerSummaryDto dto) => CustomerSummary(
        id: dto.id ?? '',
        code: _blankToNull(dto.customerId),
        name: dto.name?.trim() ?? '',
        legalName: _blankToNull(dto.legalName),
        phone: dto.phone ?? '',
        alternatePhone: _blankToNull(dto.alternatePhone),
        email: _blankToNull(dto.email),
        type: CustomerType.tryParse(dto.type),
        tier: LoyaltyTier.tryParse(dto.tier),
        status: CustomerStatus.tryParse(dto.status),
        city: _blankToNull(dto.city),
        state: _blankToNull(dto.state),
        country: _blankToNull(dto.country),
        gstin: _blankToNull(dto.gstin),
        ownerName: _blankToNull(dto.ownerUserName),
        totalBilled: dto.totalBilled?.toDouble() ?? 0,
        totalCollected: dto.totalCollected?.toDouble() ?? 0,
        outstanding: dto.outstanding?.toDouble() ?? 0,
        totalRefunded: dto.totalRefunded?.toDouble() ?? 0,
        activeBookingCount: dto.activeBookingCount ?? 0,
        cancelledBookingCount: dto.cancelledBookingCount ?? 0,
        lastBookingDate: AppDate.parseDate(dto.lastBookingDate),
        nextDueTravelDate: AppDate.parseDate(dto.nextDueTravelDate),
        leadCount: dto.leadCount ?? 0,
        quotationCount: dto.quotationCount ?? 0,
        invoiceCount: dto.invoiceCount ?? 0,
        documentCount: dto.documentCount ?? 0,
        documentsExpiringSoon: dto.documentsExpiringSoon ?? 0,
        passportExpiry: AppDate.parseDate(dto.passportExpiry),
        hasPortalAccount: dto.hasPortalAccount ?? false,
      );

  static CustomerStats toStats(CustomerStatsDto dto) => CustomerStats(
        total: dto.total ?? 0,
        active: dto.active ?? 0,
        inactive: dto.inactive ?? 0,
        blocked: dto.blocked ?? 0,
        vip: dto.vip ?? 0,
        corporate: dto.corporate ?? 0,
        regular: dto.regular ?? 0,
        totalRevenue: dto.totalRevenue?.toDouble() ?? 0,
        totalBookings: dto.totalBookings ?? 0,
        repeatCustomers: dto.repeatCustomers ?? 0,
      );

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
