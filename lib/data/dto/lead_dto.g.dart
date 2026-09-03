// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lead_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LeadDto _$LeadDtoFromJson(Map<String, dynamic> json) => _LeadDto(
  id: json['id'] as String?,
  leadCode: json['leadCode'] as String?,
  customerName: json['customerName'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  customerWhatsapp: json['customerWhatsapp'] as String?,
  customerCity: json['customerCity'] as String?,
  customerState: json['customerState'] as String?,
  customerCountry: json['customerCountry'] as String?,
  leadSource: json['leadSource'] as String?,
  leadType: json['leadType'] as String?,
  leadStage: json['leadStage'] as String?,
  assignedUser: json['assignedUser'] == null
      ? null
      : AssignedUserDto.fromJson(json['assignedUser'] as Map<String, dynamic>),
  birthDate: json['birthDate'] as String?,
  followUpDate: json['followUpDate'] as String?,
  travelDate: json['travelDate'] as String?,
  returnDate: json['returnDate'] as String?,
  budget: json['budget'] as num?,
  budgetBasis: json['budgetBasis'] as String?,
  logCount: (json['logCount'] as num?)?.toInt(),
  lastActivityAt: json['lastActivityAt'] as String?,
  departCountry: json['departCountry'] as String?,
  departCity: json['departCity'] as String?,
  departureMode: json['departureMode'] as String?,
  rooms: (json['rooms'] as num?)?.toInt(),
  adults: (json['adults'] as num?)?.toInt(),
  children: (json['children'] as num?)?.toInt(),
  infants: (json['infants'] as num?)?.toInt(),
  extraBeds: (json['extraBeds'] as num?)?.toInt(),
  services:
      (json['services'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  notes: json['notes'] as String?,
  itinerary:
      (json['itinerary'] as List<dynamic>?)
          ?.map((e) => LeadItineraryDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <LeadItineraryDto>[],
  createdAt: json['createdAt'] as String?,
  latestQuotation: json['latestQuotation'] == null
      ? null
      : QuotationRefDto.fromJson(
          json['latestQuotation'] as Map<String, dynamic>,
        ),
  convertedBookingPublicId: json['convertedBookingPublicId'] as String?,
  openToClaim: json['openToClaim'] as bool?,
  claimVersion: (json['claimVersion'] as num?)?.toInt(),
);

Map<String, dynamic> _$LeadDtoToJson(_LeadDto instance) => <String, dynamic>{
  'id': instance.id,
  'leadCode': instance.leadCode,
  'customerName': instance.customerName,
  'phone': instance.phone,
  'email': instance.email,
  'customerWhatsapp': instance.customerWhatsapp,
  'customerCity': instance.customerCity,
  'customerState': instance.customerState,
  'customerCountry': instance.customerCountry,
  'leadSource': instance.leadSource,
  'leadType': instance.leadType,
  'leadStage': instance.leadStage,
  'assignedUser': instance.assignedUser,
  'birthDate': instance.birthDate,
  'followUpDate': instance.followUpDate,
  'travelDate': instance.travelDate,
  'returnDate': instance.returnDate,
  'budget': instance.budget,
  'budgetBasis': instance.budgetBasis,
  'logCount': instance.logCount,
  'lastActivityAt': instance.lastActivityAt,
  'departCountry': instance.departCountry,
  'departCity': instance.departCity,
  'departureMode': instance.departureMode,
  'rooms': instance.rooms,
  'adults': instance.adults,
  'children': instance.children,
  'infants': instance.infants,
  'extraBeds': instance.extraBeds,
  'services': instance.services,
  'notes': instance.notes,
  'itinerary': instance.itinerary,
  'createdAt': instance.createdAt,
  'latestQuotation': instance.latestQuotation,
  'convertedBookingPublicId': instance.convertedBookingPublicId,
  'openToClaim': instance.openToClaim,
  'claimVersion': instance.claimVersion,
};

_AssignedUserDto _$AssignedUserDtoFromJson(Map<String, dynamic> json) =>
    _AssignedUserDto(
      publicId: json['publicId'] as String?,
      fullName: json['fullName'] as String?,
      role: json['role'] as String?,
      email: json['email'] as String?,
    );

Map<String, dynamic> _$AssignedUserDtoToJson(_AssignedUserDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'fullName': instance.fullName,
      'role': instance.role,
      'email': instance.email,
    };

_QuotationRefDto _$QuotationRefDtoFromJson(Map<String, dynamic> json) =>
    _QuotationRefDto(
      publicId: json['publicId'] as String?,
      grandTotal: json['grandTotal'] as num?,
      version: json['version'] as String?,
    );

Map<String, dynamic> _$QuotationRefDtoToJson(_QuotationRefDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'grandTotal': instance.grandTotal,
      'version': instance.version,
    };

_LeadItineraryDto _$LeadItineraryDtoFromJson(Map<String, dynamic> json) =>
    _LeadItineraryDto(
      id: json['id'] as String?,
      destination: json['destination'] as String?,
      city: json['city'] as String?,
      nights: (json['nights'] as num?)?.toInt(),
      dayNumber: (json['dayNumber'] as num?)?.toInt(),
      destinationId: (json['destinationId'] as num?)?.toInt(),
      cityId: (json['cityId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LeadItineraryDtoToJson(_LeadItineraryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'destination': instance.destination,
      'city': instance.city,
      'nights': instance.nights,
      'dayNumber': instance.dayNumber,
      'destinationId': instance.destinationId,
      'cityId': instance.cityId,
    };

_LeadLogDto _$LeadLogDtoFromJson(Map<String, dynamic> json) => _LeadLogDto(
  id: json['id'] as String?,
  comment: json['comment'] as String?,
  stage: json['stage'] as String?,
  followUpDate: json['followUpDate'] as String?,
  addedBy: json['addedBy'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$LeadLogDtoToJson(_LeadLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'stage': instance.stage,
      'followUpDate': instance.followUpDate,
      'addedBy': instance.addedBy,
      'createdAt': instance.createdAt,
    };

_LeadStatsSummaryDto _$LeadStatsSummaryDtoFromJson(Map<String, dynamic> json) =>
    _LeadStatsSummaryDto(
      totalLeads: (json['totalLeads'] as num?)?.toInt(),
      activeLeads: (json['activeLeads'] as num?)?.toInt(),
      convertedLeads: (json['convertedLeads'] as num?)?.toInt(),
      lostLeads: (json['lostLeads'] as num?)?.toInt(),
      proposalSentLeads: (json['proposalSentLeads'] as num?)?.toInt(),
      byStage:
          (json['byStage'] as List<dynamic>?)
              ?.map((e) => StageCountDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <StageCountDto>[],
      byType:
          (json['byType'] as List<dynamic>?)
              ?.map((e) => TypeCountDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <TypeCountDto>[],
      activePipelineValue: json['activePipelineValue'] as num?,
      activeWithBudget: (json['activeWithBudget'] as num?)?.toInt(),
      quotedValue: json['quotedValue'] as num?,
      followUpsOverdue: (json['followUpsOverdue'] as num?)?.toInt(),
      followUpsDueToday: (json['followUpsDueToday'] as num?)?.toInt(),
      createdInPeriod: (json['createdInPeriod'] as num?)?.toInt(),
      convertedInPeriod: (json['convertedInPeriod'] as num?)?.toInt(),
      conversionRate: (json['conversionRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$LeadStatsSummaryDtoToJson(
  _LeadStatsSummaryDto instance,
) => <String, dynamic>{
  'totalLeads': instance.totalLeads,
  'activeLeads': instance.activeLeads,
  'convertedLeads': instance.convertedLeads,
  'lostLeads': instance.lostLeads,
  'proposalSentLeads': instance.proposalSentLeads,
  'byStage': instance.byStage,
  'byType': instance.byType,
  'activePipelineValue': instance.activePipelineValue,
  'activeWithBudget': instance.activeWithBudget,
  'quotedValue': instance.quotedValue,
  'followUpsOverdue': instance.followUpsOverdue,
  'followUpsDueToday': instance.followUpsDueToday,
  'createdInPeriod': instance.createdInPeriod,
  'convertedInPeriod': instance.convertedInPeriod,
  'conversionRate': instance.conversionRate,
};

_StageCountDto _$StageCountDtoFromJson(Map<String, dynamic> json) =>
    _StageCountDto(
      stage: json['stage'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StageCountDtoToJson(_StageCountDto instance) =>
    <String, dynamic>{'stage': instance.stage, 'count': instance.count};

_TypeCountDto _$TypeCountDtoFromJson(Map<String, dynamic> json) =>
    _TypeCountDto(
      type: json['type'] as String?,
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TypeCountDtoToJson(_TypeCountDto instance) =>
    <String, dynamic>{'type': instance.type, 'count': instance.count};

_AssignmentRecommendationDto _$AssignmentRecommendationDtoFromJson(
  Map<String, dynamic> json,
) => _AssignmentRecommendationDto(
  strategy: json['strategy'] as String?,
  strategyLabel: json['strategyLabel'] as String?,
  forcedSelf: json['forcedSelf'] as bool? ?? false,
  self: json['self'] == null
      ? null
      : EligibleUserDto.fromJson(json['self'] as Map<String, dynamic>),
  recommendedUserId: json['recommendedUserId'] as String?,
  recommendedUserName: json['recommendedUserName'] as String?,
  eligibleUsers:
      (json['eligibleUsers'] as List<dynamic>?)
          ?.map((e) => EligibleUserDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <EligibleUserDto>[],
);

Map<String, dynamic> _$AssignmentRecommendationDtoToJson(
  _AssignmentRecommendationDto instance,
) => <String, dynamic>{
  'strategy': instance.strategy,
  'strategyLabel': instance.strategyLabel,
  'forcedSelf': instance.forcedSelf,
  'self': instance.self,
  'recommendedUserId': instance.recommendedUserId,
  'recommendedUserName': instance.recommendedUserName,
  'eligibleUsers': instance.eligibleUsers,
};

_EligibleUserDto _$EligibleUserDtoFromJson(Map<String, dynamic> json) =>
    _EligibleUserDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      activeLeads: (json['activeLeads'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EligibleUserDtoToJson(_EligibleUserDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'activeLeads': instance.activeLeads,
    };
