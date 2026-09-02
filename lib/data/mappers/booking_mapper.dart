import '../../core/formatters/app_date.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/booking_enums.dart';
import '../dto/booking_dto.dart';

/// DTO → entity for the booking module. Money passes through untouched: the
/// server computes GST, TCS, totals and profit, and the client only formats.
abstract final class BookingMapper {
  static Booking toEntity(BookingDto dto) => Booking(
        id: dto.publicId ?? '',
        code: _blankToNull(dto.bookingCode),
        customerName: dto.customerNameSnapshot?.trim() ?? '',
        customerId: _blankToNull(dto.customerId),
        destination: _blankToNull(dto.destinationSnapshot),
        leadId: _blankToNull(dto.sourceLeadPublicId),
        quotationId: _blankToNull(dto.sourceQuotationPublicId),
        agentName: _blankToNull(dto.assignedUserName),
        bookingDate: AppDate.parseDate(dto.bookingDate),
        travelDate: AppDate.parseDate(dto.travelDate),
        vendorName: _blankToNull(dto.vendorName),
        customerAmount: dto.customerAmount?.toDouble() ?? 0,
        gst: dto.gst?.toDouble() ?? 0,
        tcs: dto.tcs?.toDouble() ?? 0,
        totalPayable: dto.totalPayable?.toDouble() ?? 0,
        paidAmount: dto.paidAmount?.toDouble() ?? 0,
        pendingAmount: dto.pendingAmount?.toDouble() ?? 0,
        refundedAmount: dto.refundedAmount?.toDouble() ?? 0,
        // Absent for callers without profit-read; null means "not permitted to
        // see", which is different from zero.
        netProfit: dto.netProfit?.toDouble(),
        status: BookingStatus.tryParse(dto.status),
        paymentStatus: PaymentStatus.tryParse(dto.paymentStatus),
        services: dto.services.where((s) => s.trim().isNotEmpty).toList(growable: false),
        tripSummary: _blankToNull(dto.tripSnapshot),
        createdAt: AppDate.parseDateTime(dto.createdAt),
        overseas: dto.overseasTourPackage ?? false,
      );

  static BookingService toService(BookingServiceDto dto) => BookingService(
        id: dto.publicId ?? '',
        type: _blankToNull(dto.serviceType),
        title: _blankToNull(dto.title),
        status: ServiceItemStatus.tryParse(dto.status),
        vendorName: _blankToNull(dto.vendorName),
        confirmationNumber: _blankToNull(dto.confirmationNumber),
        serviceDate: AppDate.parseDate(dto.serviceDate),
        cost: dto.cost?.toDouble(),
      );

  static BookingStats toStats(BookingStatsDto dto) => BookingStats(
        total: dto.totalBookings ?? 0,
        confirmed: dto.confirmedBookings ?? 0,
        pending: dto.pendingBookings ?? 0,
        cancelled: dto.cancelledBookings ?? 0,
        completed: dto.completedBookings ?? 0,
        refunded: dto.refundedBookings ?? 0,
        totalRevenue: dto.totalRevenue?.toDouble() ?? 0,
        totalCollected: dto.totalCollected?.toDouble() ?? 0,
        totalPending: dto.totalPending?.toDouble() ?? 0,
        totalRefunded: dto.totalRefundAmount?.toDouble() ?? 0,
        netProfit: dto.netProfit?.toDouble(),
      );

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
