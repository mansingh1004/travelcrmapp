import 'package:freezed_annotation/freezed_annotation.dart';

part 'quotation_dto.freezed.dart';
part 'quotation_dto.g.dart';

/// Wire model for `QuotationSummaryDto` — the list row.
@freezed
abstract class QuotationSummaryDto with _$QuotationSummaryDto {
  const factory QuotationSummaryDto({
    String? publicId,
    String? leadId,
    String? title,
    int? versionNumber,
    String? pdfUrl,
    String? templateStyle,
    String? quotationStage,
    String? leadStage,
    String? customerName,
    String? destination,
    String? travelDate,
    num? grandTotal,
    String? createdAt,
  }) = _QuotationSummaryDto;

  factory QuotationSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationSummaryDtoFromJson(json);
}

/// Reads `quoteNo` as text whatever the server sends it as. The running
/// backend sends a bare number (`"quoteNo": 24`); reading it into a `String?`
/// directly throws, and the preview only ever prints it.
Object? _readQuoteNo(Map<dynamic, dynamic> json, String key) =>
    json[key]?.toString();

/// Wire model for the full quotation (`GET /api/quotations/{publicId}`).
///
/// The service blocks (`flight`, `hotel`, …) and policy lists are free-form
/// JSON the builder owns; only the parts this app renders are typed.
@freezed
abstract class QuotationDto with _$QuotationDto {
  const factory QuotationDto({
    String? publicId,
    String? leadId,
    String? title,
    /// A **number** on the wire — `"quoteNo": 24` — even though it reads as a
    /// reference. Typed loosely so a server that later pads it ("Q-0024")
    /// still parses.
    @JsonKey(readValue: _readQuoteNo) String? quoteNo,
    int? versionNumber,
    String? pdfUrl,
    String? quotationStage,
    String? templateStyle,
    String? notes,
    int? nights,
    int? days,
    int? rooms,
    QuotationCustomerDto? customer,
    QuotationTotalsDto? totals,
    QuotationHotelBlockDto? hotel,
    QuotationVehicleBlockDto? vehicle,
    QuotationFlightBlockDto? flight,
    QuotationSightseeingBlockDto? sightseeing,
    @Default(<String>[]) List<String> inclusions,
    @Default(<String>[]) List<String> exclusions,
    @Default(<String>[]) List<String> paymentPolicies,
    @Default(<String>[]) List<String> cancellationPolicies,
    @Default(<String>[]) List<String> bookingTerms,
    String? createdBy,
    String? createdAt,
  }) = _QuotationDto;

  factory QuotationDto.fromJson(Map<String, dynamic> json) => _$QuotationDtoFromJson(json);
}

/// The customer block embedded in a quotation.
@freezed
abstract class QuotationCustomerDto with _$QuotationCustomerDto {
  const factory QuotationCustomerDto({
    String? name,
    String? phone,
    String? email,
    String? destination,
    String? travelDate,
    int? adults,
    int? children,
    int? infants,
  }) = _QuotationCustomerDto;

  factory QuotationCustomerDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationCustomerDtoFromJson(json);
}

/// The price break-up. **Every figure is server-computed** — discount, markup,
/// tax and the grand total are calculated by the backend and never by the app.
@freezed
abstract class QuotationTotalsDto with _$QuotationTotalsDto {
  const factory QuotationTotalsDto({
    num? subtotal,
    String? discountType,
    num? discount,
    num? discountAmount,
    num? markup,
    num? taxPercent,
    num? taxAmount,
    num? grandTotal,
    num? addonsTotal,
    num? perAdult,
  }) = _QuotationTotalsDto;

  factory QuotationTotalsDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationTotalsDtoFromJson(json);
}

/// `hotel` — the stay block. `included` is the builder's own on/off switch, so
/// a block can carry rows while being excluded from the quoted price.
@freezed
abstract class QuotationHotelBlockDto with _$QuotationHotelBlockDto {
  const factory QuotationHotelBlockDto({
    bool? included,
    String? title,
    num? amount,
    String? notes,
    @Default(<QuotationHotelDto>[]) List<QuotationHotelDto> hotels,
  }) = _QuotationHotelBlockDto;

  factory QuotationHotelBlockDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationHotelBlockDtoFromJson(json);
}

@freezed
abstract class QuotationHotelDto with _$QuotationHotelDto {
  const factory QuotationHotelDto({
    String? name,
    String? city,
    String? checkIn,
    String? checkOut,
    String? roomType,
    String? mealPlan,
    int? stars,
    int? rooms,
    num? pricePerRoom,
  }) = _QuotationHotelDto;

  factory QuotationHotelDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationHotelDtoFromJson(json);
}

/// `vehicle` — the transport block.
@freezed
abstract class QuotationVehicleBlockDto with _$QuotationVehicleBlockDto {
  const factory QuotationVehicleBlockDto({
    bool? included,
    String? title,
    num? amount,
    @Default(<QuotationVehicleDto>[]) List<QuotationVehicleDto> vehicles,
  }) = _QuotationVehicleBlockDto;

  factory QuotationVehicleBlockDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationVehicleBlockDtoFromJson(json);
}

@freezed
abstract class QuotationVehicleDto with _$QuotationVehicleDto {
  const factory QuotationVehicleDto({
    String? type,
    String? model,
    String? pickup,
    String? drop,
    String? startDate,
    String? endDate,
    int? qty,
    num? pricePerVehicle,
  }) = _QuotationVehicleDto;

  factory QuotationVehicleDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationVehicleDtoFromJson(json);
}

/// `flight` — air segments.
@freezed
abstract class QuotationFlightBlockDto with _$QuotationFlightBlockDto {
  const factory QuotationFlightBlockDto({
    bool? included,
    String? title,
    num? amount,
    String? journey,
    @Default(<QuotationFlightSegmentDto>[]) List<QuotationFlightSegmentDto> segments,
  }) = _QuotationFlightBlockDto;

  factory QuotationFlightBlockDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationFlightBlockDtoFromJson(json);
}

@freezed
abstract class QuotationFlightSegmentDto with _$QuotationFlightSegmentDto {
  const factory QuotationFlightSegmentDto({
    String? airline,
    String? flightNo,
    /// `class` is a Dart keyword, so the wire name is mapped explicitly.
    @JsonKey(name: 'class') String? cabinClass,
    String? from,
    String? to,
    String? depDate,
    String? depTime,
    String? arrDate,
    String? arrTime,
  }) = _QuotationFlightSegmentDto;

  factory QuotationFlightSegmentDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationFlightSegmentDtoFromJson(json);
}

/// `sightseeing` — the day-wise plan. This is the closest thing the quotation
/// has to an itinerary, and it is what the preview's day plan renders.
@freezed
abstract class QuotationSightseeingBlockDto with _$QuotationSightseeingBlockDto {
  const factory QuotationSightseeingBlockDto({
    bool? included,
    String? title,
    num? amount,
    @Default(<QuotationSightseeingDayDto>[]) List<QuotationSightseeingDayDto> days,
  }) = _QuotationSightseeingBlockDto;

  factory QuotationSightseeingBlockDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationSightseeingBlockDtoFromJson(json);
}

@freezed
abstract class QuotationSightseeingDayDto with _$QuotationSightseeingDayDto {
  const factory QuotationSightseeingDayDto({
    int? day,
    String? date,
    int? pax,
    num? pricePerPax,
    @Default(<QuotationActivityDto>[]) List<QuotationActivityDto> activities,
  }) = _QuotationSightseeingDayDto;

  factory QuotationSightseeingDayDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationSightseeingDayDtoFromJson(json);
}

@freezed
abstract class QuotationActivityDto with _$QuotationActivityDto {
  const factory QuotationActivityDto({
    String? attraction,
    String? startTime,
    String? description,
    String? transfer,
  }) = _QuotationActivityDto;

  factory QuotationActivityDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationActivityDtoFromJson(json);
}
