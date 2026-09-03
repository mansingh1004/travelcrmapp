import 'package:freezed_annotation/freezed_annotation.dart';

part 'lead_dto.freezed.dart';
part 'lead_dto.g.dart';

/// Wire models for the running backend's lead module
/// (`lead/dto/LeadResponseDto` and friends — extraction `api_lead.json`).
///
/// Two deliberate choices:
///  * **Enums are held as `String?`, not Dart enums.** The wire value is the
///    display name ("New Lead", "Google Ads"), and an unrecognised value must
///    never take out a whole page — the mapper converts leniently.
///  * **Everything except `id` is nullable.** `@JsonInclude(NON_NULL)` on the
///    server means absent-when-null, and a partial row must never crash a list.
///
/// Only the subset of the ~70 response fields the app renders is modelled;
/// unknown keys are ignored by `json_serializable` by default.
@freezed
abstract class LeadDto with _$LeadDto {
  const factory LeadDto({
    /// The lead's public UUID (the server never exposes internal ids).
    String? id,
    String? leadCode,
    String? customerName,
    String? phone,
    String? email,
    String? customerWhatsapp,
    String? customerCity,
    String? customerState,
    String? customerCountry,
    String? leadSource,
    String? leadType,
    String? leadStage,
    AssignedUserDto? assignedUser,
    String? birthDate,
    String? followUpDate,
    String? travelDate,
    String? returnDate,
    num? budget,
    String? budgetBasis,
    int? logCount,
    String? lastActivityAt,
    String? departCountry,
    String? departCity,
    String? departureMode,
    int? rooms,
    int? adults,
    int? children,
    int? infants,
    int? extraBeds,
    @Default(<String>[]) List<String> services,
    String? notes,
    @Default(<LeadItineraryDto>[]) List<LeadItineraryDto> itinerary,
    String? createdAt,
    QuotationRefDto? latestQuotation,
    String? convertedBookingPublicId,
    bool? openToClaim,
    int? claimVersion,
  }) = _LeadDto;

  factory LeadDto.fromJson(Map<String, dynamic> json) => _$LeadDtoFromJson(json);
}

/// `auth.dto.UserDto` as nested in `LeadResponseDto.assignedUser`.
@freezed
abstract class AssignedUserDto with _$AssignedUserDto {
  const factory AssignedUserDto({
    String? publicId,
    String? fullName,
    String? role,
    String? email,
  }) = _AssignedUserDto;

  factory AssignedUserDto.fromJson(Map<String, dynamic> json) =>
      _$AssignedUserDtoFromJson(json);
}

/// `QuotationRefDto` — the lead's latest quotation pointer.
@freezed
abstract class QuotationRefDto with _$QuotationRefDto {
  const factory QuotationRefDto({
    String? publicId,
    num? grandTotal,
    /// A **label**, not a number: the server sends `"v1.0"`.
    String? version,
  }) = _QuotationRefDto;

  factory QuotationRefDto.fromJson(Map<String, dynamic> json) =>
      _$QuotationRefDtoFromJson(json);
}

/// Nested `LeadResponseDto.itinerary[]` item.
@freezed
abstract class LeadItineraryDto with _$LeadItineraryDto {
  const factory LeadItineraryDto({
    /// A UUID string, like every other public id the server exposes.
    String? id,
    String? destination,
    String? city,
    int? nights,
    int? dayNumber,
    /// The geography ids behind the two names above. A quotation needs the
    /// destination id to filter the hotel and sightseeing masters by it.
    int? destinationId,
    int? cityId,
  }) = _LeadItineraryDto;

  factory LeadItineraryDto.fromJson(Map<String, dynamic> json) => _$LeadItineraryDtoFromJson(json);
}

/// `lead/dto/LeadLogResponseDto` — one activity-log entry.
@freezed
abstract class LeadLogDto with _$LeadLogDto {
  const factory LeadLogDto({
    String? id,
    String? comment,
    String? stage,
    String? followUpDate,
    String? addedBy,
    String? createdAt,
  }) = _LeadLogDto;

  factory LeadLogDto.fromJson(Map<String, dynamic> json) => _$LeadLogDtoFromJson(json);
}

/// `GET /api/leads/stats/summary` → `LeadStatsSummaryDto` (subset).
@freezed
abstract class LeadStatsSummaryDto with _$LeadStatsSummaryDto {
  const factory LeadStatsSummaryDto({
    int? totalLeads,
    int? activeLeads,
    int? convertedLeads,
    int? lostLeads,
    int? proposalSentLeads,
    @Default(<StageCountDto>[]) List<StageCountDto> byStage,
    @Default(<TypeCountDto>[]) List<TypeCountDto> byType,
    num? activePipelineValue,
    int? activeWithBudget,
    num? quotedValue,
    int? followUpsOverdue,
    int? followUpsDueToday,
    int? createdInPeriod,
    int? convertedInPeriod,
    // Percentage; null when createdInPeriod == 0 — null and 0 differ.
    double? conversionRate,
  }) = _LeadStatsSummaryDto;

  factory LeadStatsSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$LeadStatsSummaryDtoFromJson(json);
}

@freezed
abstract class StageCountDto with _$StageCountDto {
  const factory StageCountDto({String? stage, int? count}) = _StageCountDto;

  factory StageCountDto.fromJson(Map<String, dynamic> json) => _$StageCountDtoFromJson(json);
}

@freezed
abstract class TypeCountDto with _$TypeCountDto {
  const factory TypeCountDto({String? type, int? count}) = _TypeCountDto;

  factory TypeCountDto.fromJson(Map<String, dynamic> json) => _$TypeCountDtoFromJson(json);
}

/// `GET /api/leads/assignment/recommendation` → who can own a new lead.
@freezed
abstract class AssignmentRecommendationDto with _$AssignmentRecommendationDto {
  const factory AssignmentRecommendationDto({
    String? strategy,
    String? strategyLabel,
    @Default(false) bool forcedSelf,
    EligibleUserDto? self,
    String? recommendedUserId,
    String? recommendedUserName,
    @Default(<EligibleUserDto>[]) List<EligibleUserDto> eligibleUsers,
  }) = _AssignmentRecommendationDto;

  factory AssignmentRecommendationDto.fromJson(Map<String, dynamic> json) =>
      _$AssignmentRecommendationDtoFromJson(json);
}

@freezed
abstract class EligibleUserDto with _$EligibleUserDto {
  const factory EligibleUserDto({
    String? id,
    String? name,
    String? email,
    int? activeLeads,
  }) = _EligibleUserDto;

  factory EligibleUserDto.fromJson(Map<String, dynamic> json) => _$EligibleUserDtoFromJson(json);
}
