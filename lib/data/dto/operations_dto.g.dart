// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operations_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OpsBoardRowDto _$OpsBoardRowDtoFromJson(Map<String, dynamic> json) =>
    _OpsBoardRowDto(
      bookingPublicId: json['bookingPublicId'] as String?,
      bookingCode: json['bookingCode'] as String?,
      customerName: json['customerName'] as String?,
      destination: json['destination'] as String?,
      travelDate: json['travelDate'] as String?,
      tripEndDate: json['tripEndDate'] as String?,
      daysToDeparture: (json['daysToDeparture'] as num?)?.toInt(),
      status: json['status'] as String?,
      paymentStatus: json['paymentStatus'] as String?,
      readiness:
          (json['readiness'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
      dimensionCounts:
          (json['dimensionCounts'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
              k,
              DimensionCountDto.fromJson(e as Map<String, dynamic>),
            ),
          ) ??
          const <String, DimensionCountDto>{},
      suppliersConfirmed: (json['suppliersConfirmed'] as num?)?.toInt(),
      suppliersTotal: (json['suppliersTotal'] as num?)?.toInt(),
      pax: (json['pax'] as num?)?.toInt(),
      balanceDue: json['balanceDue'] as num?,
      needsAttention: json['needsAttention'] as bool?,
      overallStatus: json['overallStatus'] as String?,
      ops: json['ops'] == null
          ? null
          : OpsStandingDto.fromJson(json['ops'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OpsBoardRowDtoToJson(_OpsBoardRowDto instance) =>
    <String, dynamic>{
      'bookingPublicId': instance.bookingPublicId,
      'bookingCode': instance.bookingCode,
      'customerName': instance.customerName,
      'destination': instance.destination,
      'travelDate': instance.travelDate,
      'tripEndDate': instance.tripEndDate,
      'daysToDeparture': instance.daysToDeparture,
      'status': instance.status,
      'paymentStatus': instance.paymentStatus,
      'readiness': instance.readiness,
      'dimensionCounts': instance.dimensionCounts,
      'suppliersConfirmed': instance.suppliersConfirmed,
      'suppliersTotal': instance.suppliersTotal,
      'pax': instance.pax,
      'balanceDue': instance.balanceDue,
      'needsAttention': instance.needsAttention,
      'overallStatus': instance.overallStatus,
      'ops': instance.ops,
    };

_DimensionCountDto _$DimensionCountDtoFromJson(Map<String, dynamic> json) =>
    _DimensionCountDto(
      confirmed: (json['confirmed'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DimensionCountDtoToJson(_DimensionCountDto instance) =>
    <String, dynamic>{'confirmed': instance.confirmed, 'total': instance.total};

_OpsStandingDto _$OpsStandingDtoFromJson(Map<String, dynamic> json) =>
    _OpsStandingDto(
      severity: json['severity'] as String?,
      hoursToDeparture: (json['hoursToDeparture'] as num?)?.toInt(),
      departureAt: json['departureAt'] as String?,
      departureAtSourceLabel: json['departureAtSourceLabel'] as String?,
      opsOwnerPublicId: json['opsOwnerPublicId'] as String?,
      opsOwnerName: json['opsOwnerName'] as String?,
      readyToTravel: json['readyToTravel'] as bool?,
    );

Map<String, dynamic> _$OpsStandingDtoToJson(_OpsStandingDto instance) =>
    <String, dynamic>{
      'severity': instance.severity,
      'hoursToDeparture': instance.hoursToDeparture,
      'departureAt': instance.departureAt,
      'departureAtSourceLabel': instance.departureAtSourceLabel,
      'opsOwnerPublicId': instance.opsOwnerPublicId,
      'opsOwnerName': instance.opsOwnerName,
      'readyToTravel': instance.readyToTravel,
    };

_OpsSummaryDto _$OpsSummaryDtoFromJson(Map<String, dynamic> json) =>
    _OpsSummaryDto(
      from: json['from'] as String?,
      to: json['to'] as String?,
      totalBookings: (json['totalBookings'] as num?)?.toInt(),
      ready: (json['ready'] as num?)?.toInt(),
      actionNeeded: (json['actionNeeded'] as num?)?.toInt(),
      urgent: (json['urgent'] as num?)?.toInt(),
      balancePending: json['balancePending'] as num?,
    );

Map<String, dynamic> _$OpsSummaryDtoToJson(_OpsSummaryDto instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
      'totalBookings': instance.totalBookings,
      'ready': instance.ready,
      'actionNeeded': instance.actionNeeded,
      'urgent': instance.urgent,
      'balancePending': instance.balancePending,
    };

_OpsDetailDto _$OpsDetailDtoFromJson(Map<String, dynamic> json) =>
    _OpsDetailDto(
      publicId: json['publicId'] as String?,
      bookingPublicId: json['bookingPublicId'] as String?,
      bookingCode: json['bookingCode'] as String?,
      opsOwnerPublicId: json['opsOwnerPublicId'] as String?,
      opsOwnerName: json['opsOwnerName'] as String?,
      departureAt: json['departureAt'] as String?,
      departureAtSourceLabel: json['departureAtSourceLabel'] as String?,
      tripEndDate: json['tripEndDate'] as String?,
      pickupLocation: json['pickupLocation'] as String?,
      pickupAt: json['pickupAt'] as String?,
      dropLocation: json['dropLocation'] as String?,
      dropAt: json['dropAt'] as String?,
      severity: json['severity'] as String?,
      hoursToDeparture: (json['hoursToDeparture'] as num?)?.toInt(),
      readyToTravel: json['readyToTravel'] as bool?,
      checkpoints:
          (json['checkpoints'] as List<dynamic>?)
              ?.map((e) => OpsCheckpointDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <OpsCheckpointDto>[],
    );

Map<String, dynamic> _$OpsDetailDtoToJson(_OpsDetailDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'bookingPublicId': instance.bookingPublicId,
      'bookingCode': instance.bookingCode,
      'opsOwnerPublicId': instance.opsOwnerPublicId,
      'opsOwnerName': instance.opsOwnerName,
      'departureAt': instance.departureAt,
      'departureAtSourceLabel': instance.departureAtSourceLabel,
      'tripEndDate': instance.tripEndDate,
      'pickupLocation': instance.pickupLocation,
      'pickupAt': instance.pickupAt,
      'dropLocation': instance.dropLocation,
      'dropAt': instance.dropAt,
      'severity': instance.severity,
      'hoursToDeparture': instance.hoursToDeparture,
      'readyToTravel': instance.readyToTravel,
      'checkpoints': instance.checkpoints,
    };

_OpsCheckpointDto _$OpsCheckpointDtoFromJson(Map<String, dynamic> json) =>
    _OpsCheckpointDto(
      publicId: json['publicId'] as String?,
      checkpoint: json['checkpoint'] as String?,
      status: json['status'] as String?,
      source: json['source'] as String?,
      vendorName: json['vendorName'] as String?,
      referenceNo: json['referenceNo'] as String?,
      notes: json['notes'] as String?,
      dueAt: json['dueAt'] as String?,
      mandatory: json['mandatory'] as bool?,
    );

Map<String, dynamic> _$OpsCheckpointDtoToJson(_OpsCheckpointDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'checkpoint': instance.checkpoint,
      'status': instance.status,
      'source': instance.source,
      'vendorName': instance.vendorName,
      'referenceNo': instance.referenceNo,
      'notes': instance.notes,
      'dueAt': instance.dueAt,
      'mandatory': instance.mandatory,
    };
