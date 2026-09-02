import '../../core/formatters/app_date.dart';
import '../../domain/entities/quotation.dart';
import '../../domain/entities/quotation_enums.dart';
import '../dto/quotation_dto.dart';

abstract final class QuotationMapper {
  static QuotationSummary toSummary(QuotationSummaryDto dto) => QuotationSummary(
        id: dto.publicId ?? '',
        leadId: _blankToNull(dto.leadId),
        title: _blankToNull(dto.title),
        version: dto.versionNumber,
        pdfUrl: _blankToNull(dto.pdfUrl),
        templateStyle: TemplateStyle.tryParse(dto.templateStyle),
        stage: QuotationStage.tryParse(dto.quotationStage),
        customerName: dto.customerName?.trim() ?? '',
        destination: _blankToNull(dto.destination),
        travelDate: AppDate.parseDate(dto.travelDate),
        grandTotal: dto.grandTotal?.toDouble() ?? 0,
        createdAt: AppDate.parseDateTime(dto.createdAt),
      );

  static Quotation toEntity(QuotationDto dto) => Quotation(
        id: dto.publicId ?? '',
        leadId: _blankToNull(dto.leadId),
        title: _blankToNull(dto.title),
        quoteNo: _blankToNull(dto.quoteNo),
        version: dto.versionNumber,
        pdfUrl: _blankToNull(dto.pdfUrl),
        stage: QuotationStage.tryParse(dto.quotationStage),
        templateStyle: TemplateStyle.tryParse(dto.templateStyle),
        notes: _blankToNull(dto.notes),
        nights: dto.nights,
        days: dto.days,
        rooms: dto.rooms,
        customer: dto.customer == null ? null : _toCustomer(dto.customer!),
        totals: dto.totals == null ? null : _toTotals(dto.totals!),
        hotels: (dto.hotel?.hotels ?? const [])
            .where((h) => (h.name ?? '').trim().isNotEmpty)
            .map(_toStay)
            .toList(growable: false),
        vehicles: (dto.vehicle?.vehicles ?? const []).map(_toTransport).toList(growable: false),
        flights: (dto.flight?.segments ?? const []).map(_toFlight).toList(growable: false),
        dayPlan: _toDayPlan(dto.sightseeing),
        inclusions: _clean(dto.inclusions),
        exclusions: _clean(dto.exclusions),
        paymentPolicies: _clean(dto.paymentPolicies),
        cancellationPolicies: _clean(dto.cancellationPolicies),
        bookingTerms: _clean(dto.bookingTerms),
        createdBy: _blankToNull(dto.createdBy),
        createdAt: AppDate.parseDateTime(dto.createdAt),
      );

  static QuotationCustomer _toCustomer(QuotationCustomerDto dto) => QuotationCustomer(
        name: _blankToNull(dto.name),
        phone: _blankToNull(dto.phone),
        email: _blankToNull(dto.email),
        destination: _blankToNull(dto.destination),
        travelDate: AppDate.parseDate(dto.travelDate),
        adults: dto.adults,
        children: dto.children,
        infants: dto.infants,
      );

  static QuotationTotals _toTotals(QuotationTotalsDto dto) => QuotationTotals(
        subtotal: dto.subtotal?.toDouble() ?? 0,
        discountType: _blankToNull(dto.discountType),
        discount: dto.discount?.toDouble() ?? 0,
        discountAmount: dto.discountAmount?.toDouble() ?? 0,
        markup: dto.markup?.toDouble() ?? 0,
        taxPercent: dto.taxPercent?.toDouble() ?? 0,
        taxAmount: dto.taxAmount?.toDouble() ?? 0,
        grandTotal: dto.grandTotal?.toDouble() ?? 0,
        addonsTotal: dto.addonsTotal?.toDouble() ?? 0,
        perAdult: dto.perAdult?.toDouble(),
      );

  static QuotationStay _toStay(QuotationHotelDto dto) => QuotationStay(
        name: dto.name!.trim(),
        city: _blankToNull(dto.city),
        checkIn: AppDate.parseDate(dto.checkIn),
        checkOut: AppDate.parseDate(dto.checkOut),
        roomType: _blankToNull(dto.roomType),
        mealPlan: _blankToNull(dto.mealPlan),
        // A zero star rating means "unrated", not "zero stars".
        stars: (dto.stars ?? 0) > 0 ? dto.stars : null,
        rooms: dto.rooms,
        pricePerRoom: dto.pricePerRoom?.toDouble(),
      );

  static QuotationTransport _toTransport(QuotationVehicleDto dto) => QuotationTransport(
        type: _blankToNull(dto.type),
        model: _blankToNull(dto.model),
        pickup: _blankToNull(dto.pickup),
        drop: _blankToNull(dto.drop),
        startDate: AppDate.parseDate(dto.startDate),
        endDate: AppDate.parseDate(dto.endDate),
        qty: dto.qty,
        pricePerVehicle: dto.pricePerVehicle?.toDouble(),
      );

  static QuotationFlightLeg _toFlight(QuotationFlightSegmentDto dto) => QuotationFlightLeg(
        airline: _blankToNull(dto.airline),
        flightNo: _blankToNull(dto.flightNo),
        cabinClass: _blankToNull(dto.cabinClass),
        from: _blankToNull(dto.from),
        to: _blankToNull(dto.to),
        departure: AppDate.parseDate(dto.depDate),
        departureTime: _blankToNull(dto.depTime),
      );

  /// Days arrive keyed by their own day number, which the builder may leave
  /// out of order; the preview reads them in order.
  static List<QuotationDay> _toDayPlan(QuotationSightseeingBlockDto? block) {
    final days = (block?.days ?? const <QuotationSightseeingDayDto>[])
        .map(
          (d) => QuotationDay(
            day: d.day ?? 0,
            date: AppDate.parseDate(d.date),
            activities: d.activities
                .where((a) => (a.attraction ?? '').trim().isNotEmpty)
                .map(
                  (a) => QuotationActivity(
                    attraction: a.attraction!.trim(),
                    description: _blankToNull(a.description),
                    startTime: _blankToNull(a.startTime),
                    transfer: _blankToNull(a.transfer),
                  ),
                )
                .toList(growable: false),
          ),
        )
        .where((d) => d.activities.isNotEmpty)
        .toList();
    days.sort((a, b) => a.day.compareTo(b.day));
    return List.unmodifiable(days);
  }

  static List<String> _clean(List<String> values) =>
      values.where((v) => v.trim().isNotEmpty).toList(growable: false);

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
