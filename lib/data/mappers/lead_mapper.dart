import '../../core/formatters/app_date.dart';
import '../../core/formatters/phone.dart';
import '../../domain/entities/lead.dart';
import '../../domain/entities/lead_enums.dart';
import '../dto/lead_dto.dart';

/// DTO ↔ entity conversion for the running backend's lead module.
///
/// Lenient in both directions: an unknown enum value or an unparseable date
/// yields `null` on that one field rather than throwing, so a single bad row
/// cannot blank an entire page of leads.
abstract final class LeadMapper {
  static Lead toEntity(LeadDto dto) => Lead(
        // publicId is always present on a real response; '' marks a malformed
        // row so it can be filtered rather than crash.
        id: dto.id ?? '',
        leadCode: _blankToNull(dto.leadCode),
        customerName: dto.customerName?.trim() ?? '',
        phone: dto.phone ?? '',
        email: _blankToNull(dto.email),
        whatsapp: _blankToNull(dto.customerWhatsapp),
        city: _blankToNull(dto.customerCity),
        state: _blankToNull(dto.customerState),
        country: _blankToNull(dto.customerCountry),
        source: _blankToNull(dto.leadSource),
        type: LeadType.tryParse(dto.leadType),
        stage: LeadStage.tryParse(dto.leadStage),
        assignedTo: dto.assignedUser?.publicId == null
            ? null
            : AssignedAgent(
                id: dto.assignedUser!.publicId!,
                name: dto.assignedUser!.fullName?.trim() ?? '—',
                role: dto.assignedUser!.role,
                email: dto.assignedUser!.email,
              ),
        birthDate: AppDate.parseDate(dto.birthDate),
        followUpDate: AppDate.parseDate(dto.followUpDate),
        travelDate: AppDate.parseDate(dto.travelDate),
        returnDate: AppDate.parseDate(dto.returnDate),
        budget: dto.budget?.toDouble(),
        logCount: dto.logCount ?? 0,
        lastActivityAt: AppDate.parseDateTime(dto.lastActivityAt),
        departCountry: _blankToNull(dto.departCountry),
        departCity: _blankToNull(dto.departCity),
        rooms: dto.rooms,
        adults: dto.adults,
        children: dto.children,
        infants: dto.infants,
        extraBeds: dto.extraBeds,
        // Carried so an edit can post the whole lead back unchanged — see the
        // note on these fields in `Lead`.
        male: dto.male,
        female: dto.female,
        packageType: _blankToNull(dto.packageType),
        departureMode: _blankToNull(dto.departureMode),
        specialAssistanceRequired: dto.specialAssistanceRequired,
        assistancePassengerCount: dto.assistancePassengerCount,
        specialAssistanceNotes: _blankToNull(dto.specialAssistanceNotes),
        services: dto.services.where((s) => s.trim().isNotEmpty).toList(growable: false),
        notes: _blankToNull(dto.notes),
        itinerary: dto.itinerary
            .map(
              (i) => LeadItineraryStop(
                id: i.id,
                destination: i.destination?.trim() ?? '',
                city: i.city?.trim() ?? '',
                nights: i.nights ?? 0,
                destinationId: i.destinationId,
              ),
            )
            .toList(growable: false),
        createdAt: AppDate.parseDateTime(dto.createdAt),
        latestQuotationTotal: dto.latestQuotation?.grandTotal?.toDouble(),
        convertedBookingId: _blankToNull(dto.convertedBookingPublicId),
        openToClaim: dto.openToClaim ?? false,
      );

  static LeadLog toLog(LeadLogDto dto) => LeadLog(
        id: dto.id ?? '',
        comment: dto.comment ?? '',
        stage: LeadStage.tryParse(dto.stage),
        followUpDate: AppDate.parseDate(dto.followUpDate),
        addedBy: _blankToNull(dto.addedBy),
        createdAt: AppDate.parseDateTime(dto.createdAt),
      );

  static LeadStats toStats(LeadStatsSummaryDto dto) {
    final byStage = <LeadStage, int>{};
    for (final row in dto.byStage) {
      final stage = LeadStage.tryParse(row.stage);
      if (stage != null) byStage[stage] = row.count ?? 0;
    }
    final byType = <LeadType, int>{};
    for (final row in dto.byType) {
      final type = LeadType.tryParse(row.type);
      if (type != null) byType[type] = row.count ?? 0;
    }
    return LeadStats(
      totalLeads: dto.totalLeads ?? 0,
      activeLeads: dto.activeLeads ?? 0,
      convertedLeads: dto.convertedLeads ?? 0,
      lostLeads: dto.lostLeads ?? 0,
      proposalSentLeads: dto.proposalSentLeads ?? 0,
      byStage: byStage,
      byType: byType,
      activePipelineValue: dto.activePipelineValue?.toDouble() ?? 0,
      quotedValue: dto.quotedValue?.toDouble() ?? 0,
      followUpsOverdue: dto.followUpsOverdue ?? 0,
      followUpsDueToday: dto.followUpsDueToday ?? 0,
      createdInPeriod: dto.createdInPeriod ?? 0,
      convertedInPeriod: dto.convertedInPeriod ?? 0,
      conversionRate: dto.conversionRate,
    );
  }

  static AssignmentChoice toAssignmentChoice(AssignmentRecommendationDto dto) => AssignmentChoice(
        forcedSelf: dto.forcedSelf,
        self: _toAgent(dto.self),
        recommendedUserId: dto.recommendedUserId,
        eligibleUsers: dto.eligibleUsers
            .map(_toAgent)
            .whereType<EligibleAgent>()
            .toList(growable: false),
        strategyLabel: dto.strategyLabel,
      );

  static EligibleAgent? _toAgent(EligibleUserDto? dto) {
    if (dto?.id == null) return null;
    return EligibleAgent(
      id: dto!.id!,
      name: dto.name?.trim() ?? '—',
      activeLeads: dto.activeLeads,
    );
  }

  /// Build the `POST /api/leads` / `PUT /api/leads/{id}` body.
  ///
  /// Enums are written as display names (the server also accepts constant
  /// names); nulls are stripped so `@Min`-constrained counts aren't tripped by
  /// blank wizard fields. The server requires `assignedUserId`.
  static Map<String, dynamic> createBody({
    required String customerName,
    required String phone,
    String? email,
    String? whatsapp,
    String? city,
    String? state,
    String? country,
    required String sourceWire,
    required LeadType type,
    required LeadStage stage,
    required String assignedUserId,
    DateTime? birthDate,
    DateTime? followUpDate,
    DateTime? travelDate,
    DateTime? returnDate,
    double? budget,
    String? departCountry,
    String? departCity,
    int? rooms,
    int? adults,
    int? male,
    int? female,
    int? children,
    int? infants,
    int? extraBeds,
    String? packageType,
    String? departureModeWire,
    bool? specialAssistanceRequired,
    int? assistancePassengerCount,
    String? specialAssistanceNotes,
    List<String>? services,
    String? notes,
    List<LeadItineraryStop>? itinerary,
  }) {
    final body = <String, dynamic>{
      'customerName': customerName.trim(),
      'phone': Phone.normalise(phone),
      'email': _blankToNull(email?.toLowerCase()),
      'customerWhatsapp': _blankToNull(whatsapp),
      'customerCity': _blankToNull(city),
      'customerState': _blankToNull(state),
      'customerCountry': _blankToNull(country),
      'leadSource': sourceWire,
      'leadType': type.wire,
      'leadStage': stage.wire,
      'assignedUserId': assignedUserId,
      'birthDate': birthDate == null ? null : AppDate.toWire(birthDate),
      'followUpDate': followUpDate == null ? null : AppDate.toWire(followUpDate),
      'travelDate': travelDate == null ? null : AppDate.toWire(travelDate),
      'returnDate': returnDate == null ? null : AppDate.toWire(returnDate),
      'budget': budget,
      'departCountry': _blankToNull(departCountry),
      'departCity': _blankToNull(departCity),
      'rooms': rooms,
      'adults': adults,
      'male': male,
      'female': female,
      'children': children,
      'infants': infants,
      'extraBeds': extraBeds,
      'packageType': _blankToNull(packageType),
      'departureMode': _blankToNull(departureModeWire),
      'specialAssistanceRequired': specialAssistanceRequired,
      'assistancePassengerCount': assistancePassengerCount,
      'specialAssistanceNotes': _blankToNull(specialAssistanceNotes),
      'services': (services == null || services.isEmpty) ? null : services,
      'notes': _blankToNull(notes),
      'itinerary': (itinerary == null || itinerary.isEmpty)
          ? null
          : itinerary
              .map(
                (s) => {
                  'destination': s.destination.trim(),
                  'city': s.city.trim(),
                  'nights': s.nights,
                },
              )
              .toList(growable: false),
    };
    body.removeWhere((_, value) => value == null);
    return body;
  }

  static String? _blankToNull(String? value) {
    final trimmed = value?.trim();
    return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }
}
