// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuotationSummaryDto _$QuotationSummaryDtoFromJson(Map<String, dynamic> json) =>
    _QuotationSummaryDto(
      publicId: json['publicId'] as String?,
      leadId: json['leadId'] as String?,
      title: json['title'] as String?,
      versionNumber: (json['versionNumber'] as num?)?.toInt(),
      pdfUrl: json['pdfUrl'] as String?,
      templateStyle: json['templateStyle'] as String?,
      quotationStage: json['quotationStage'] as String?,
      leadStage: json['leadStage'] as String?,
      customerName: json['customerName'] as String?,
      destination: json['destination'] as String?,
      travelDate: json['travelDate'] as String?,
      grandTotal: json['grandTotal'] as num?,
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$QuotationSummaryDtoToJson(
  _QuotationSummaryDto instance,
) => <String, dynamic>{
  'publicId': instance.publicId,
  'leadId': instance.leadId,
  'title': instance.title,
  'versionNumber': instance.versionNumber,
  'pdfUrl': instance.pdfUrl,
  'templateStyle': instance.templateStyle,
  'quotationStage': instance.quotationStage,
  'leadStage': instance.leadStage,
  'customerName': instance.customerName,
  'destination': instance.destination,
  'travelDate': instance.travelDate,
  'grandTotal': instance.grandTotal,
  'createdAt': instance.createdAt,
};

_QuotationDto _$QuotationDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationDto(
  publicId: json['publicId'] as String?,
  leadId: json['leadId'] as String?,
  title: json['title'] as String?,
  quoteNo: _readQuoteNo(json, 'quoteNo') as String?,
  versionNumber: (json['versionNumber'] as num?)?.toInt(),
  pdfUrl: json['pdfUrl'] as String?,
  quotationStage: json['quotationStage'] as String?,
  templateStyle: json['templateStyle'] as String?,
  notes: json['notes'] as String?,
  nights: (json['nights'] as num?)?.toInt(),
  days: (json['days'] as num?)?.toInt(),
  rooms: (json['rooms'] as num?)?.toInt(),
  customer: json['customer'] == null
      ? null
      : QuotationCustomerDto.fromJson(json['customer'] as Map<String, dynamic>),
  totals: json['totals'] == null
      ? null
      : QuotationTotalsDto.fromJson(json['totals'] as Map<String, dynamic>),
  hotel: json['hotel'] == null
      ? null
      : QuotationHotelBlockDto.fromJson(json['hotel'] as Map<String, dynamic>),
  vehicle: json['vehicle'] == null
      ? null
      : QuotationVehicleBlockDto.fromJson(
          json['vehicle'] as Map<String, dynamic>,
        ),
  flight: json['flight'] == null
      ? null
      : QuotationFlightBlockDto.fromJson(
          json['flight'] as Map<String, dynamic>,
        ),
  sightseeing: json['sightseeing'] == null
      ? null
      : QuotationSightseeingBlockDto.fromJson(
          json['sightseeing'] as Map<String, dynamic>,
        ),
  inclusions:
      (json['inclusions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  exclusions:
      (json['exclusions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  paymentPolicies:
      (json['paymentPolicies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  cancellationPolicies:
      (json['cancellationPolicies'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  bookingTerms:
      (json['bookingTerms'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  createdBy: json['createdBy'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$QuotationDtoToJson(_QuotationDto instance) =>
    <String, dynamic>{
      'publicId': instance.publicId,
      'leadId': instance.leadId,
      'title': instance.title,
      'quoteNo': instance.quoteNo,
      'versionNumber': instance.versionNumber,
      'pdfUrl': instance.pdfUrl,
      'quotationStage': instance.quotationStage,
      'templateStyle': instance.templateStyle,
      'notes': instance.notes,
      'nights': instance.nights,
      'days': instance.days,
      'rooms': instance.rooms,
      'customer': instance.customer,
      'totals': instance.totals,
      'hotel': instance.hotel,
      'vehicle': instance.vehicle,
      'flight': instance.flight,
      'sightseeing': instance.sightseeing,
      'inclusions': instance.inclusions,
      'exclusions': instance.exclusions,
      'paymentPolicies': instance.paymentPolicies,
      'cancellationPolicies': instance.cancellationPolicies,
      'bookingTerms': instance.bookingTerms,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt,
    };

_QuotationCustomerDto _$QuotationCustomerDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationCustomerDto(
  name: json['name'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  destination: json['destination'] as String?,
  travelDate: json['travelDate'] as String?,
  adults: (json['adults'] as num?)?.toInt(),
  children: (json['children'] as num?)?.toInt(),
  infants: (json['infants'] as num?)?.toInt(),
);

Map<String, dynamic> _$QuotationCustomerDtoToJson(
  _QuotationCustomerDto instance,
) => <String, dynamic>{
  'name': instance.name,
  'phone': instance.phone,
  'email': instance.email,
  'destination': instance.destination,
  'travelDate': instance.travelDate,
  'adults': instance.adults,
  'children': instance.children,
  'infants': instance.infants,
};

_QuotationTotalsDto _$QuotationTotalsDtoFromJson(Map<String, dynamic> json) =>
    _QuotationTotalsDto(
      subtotal: json['subtotal'] as num?,
      discountType: json['discountType'] as String?,
      discount: json['discount'] as num?,
      discountAmount: json['discountAmount'] as num?,
      markup: json['markup'] as num?,
      taxPercent: json['taxPercent'] as num?,
      taxAmount: json['taxAmount'] as num?,
      grandTotal: json['grandTotal'] as num?,
      addonsTotal: json['addonsTotal'] as num?,
      perAdult: json['perAdult'] as num?,
    );

Map<String, dynamic> _$QuotationTotalsDtoToJson(_QuotationTotalsDto instance) =>
    <String, dynamic>{
      'subtotal': instance.subtotal,
      'discountType': instance.discountType,
      'discount': instance.discount,
      'discountAmount': instance.discountAmount,
      'markup': instance.markup,
      'taxPercent': instance.taxPercent,
      'taxAmount': instance.taxAmount,
      'grandTotal': instance.grandTotal,
      'addonsTotal': instance.addonsTotal,
      'perAdult': instance.perAdult,
    };

_QuotationHotelBlockDto _$QuotationHotelBlockDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationHotelBlockDto(
  included: json['included'] as bool?,
  title: json['title'] as String?,
  amount: json['amount'] as num?,
  notes: json['notes'] as String?,
  hotels:
      (json['hotels'] as List<dynamic>?)
          ?.map((e) => QuotationHotelDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuotationHotelDto>[],
);

Map<String, dynamic> _$QuotationHotelBlockDtoToJson(
  _QuotationHotelBlockDto instance,
) => <String, dynamic>{
  'included': instance.included,
  'title': instance.title,
  'amount': instance.amount,
  'notes': instance.notes,
  'hotels': instance.hotels,
};

_QuotationHotelDto _$QuotationHotelDtoFromJson(Map<String, dynamic> json) =>
    _QuotationHotelDto(
      name: json['name'] as String?,
      city: json['city'] as String?,
      checkIn: json['checkIn'] as String?,
      checkOut: json['checkOut'] as String?,
      roomType: json['roomType'] as String?,
      mealPlan: json['mealPlan'] as String?,
      stars: (json['stars'] as num?)?.toInt(),
      rooms: (json['rooms'] as num?)?.toInt(),
      pricePerRoom: json['pricePerRoom'] as num?,
    );

Map<String, dynamic> _$QuotationHotelDtoToJson(_QuotationHotelDto instance) =>
    <String, dynamic>{
      'name': instance.name,
      'city': instance.city,
      'checkIn': instance.checkIn,
      'checkOut': instance.checkOut,
      'roomType': instance.roomType,
      'mealPlan': instance.mealPlan,
      'stars': instance.stars,
      'rooms': instance.rooms,
      'pricePerRoom': instance.pricePerRoom,
    };

_QuotationVehicleBlockDto _$QuotationVehicleBlockDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationVehicleBlockDto(
  included: json['included'] as bool?,
  title: json['title'] as String?,
  amount: json['amount'] as num?,
  vehicles:
      (json['vehicles'] as List<dynamic>?)
          ?.map((e) => QuotationVehicleDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuotationVehicleDto>[],
);

Map<String, dynamic> _$QuotationVehicleBlockDtoToJson(
  _QuotationVehicleBlockDto instance,
) => <String, dynamic>{
  'included': instance.included,
  'title': instance.title,
  'amount': instance.amount,
  'vehicles': instance.vehicles,
};

_QuotationVehicleDto _$QuotationVehicleDtoFromJson(Map<String, dynamic> json) =>
    _QuotationVehicleDto(
      type: json['type'] as String?,
      model: json['model'] as String?,
      pickup: json['pickup'] as String?,
      drop: json['drop'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      qty: (json['qty'] as num?)?.toInt(),
      pricePerVehicle: json['pricePerVehicle'] as num?,
    );

Map<String, dynamic> _$QuotationVehicleDtoToJson(
  _QuotationVehicleDto instance,
) => <String, dynamic>{
  'type': instance.type,
  'model': instance.model,
  'pickup': instance.pickup,
  'drop': instance.drop,
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'qty': instance.qty,
  'pricePerVehicle': instance.pricePerVehicle,
};

_QuotationFlightBlockDto _$QuotationFlightBlockDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationFlightBlockDto(
  included: json['included'] as bool?,
  title: json['title'] as String?,
  amount: json['amount'] as num?,
  journey: json['journey'] as String?,
  segments:
      (json['segments'] as List<dynamic>?)
          ?.map(
            (e) =>
                QuotationFlightSegmentDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <QuotationFlightSegmentDto>[],
);

Map<String, dynamic> _$QuotationFlightBlockDtoToJson(
  _QuotationFlightBlockDto instance,
) => <String, dynamic>{
  'included': instance.included,
  'title': instance.title,
  'amount': instance.amount,
  'journey': instance.journey,
  'segments': instance.segments,
};

_QuotationFlightSegmentDto _$QuotationFlightSegmentDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationFlightSegmentDto(
  airline: json['airline'] as String?,
  flightNo: json['flightNo'] as String?,
  cabinClass: json['class'] as String?,
  from: json['from'] as String?,
  to: json['to'] as String?,
  depDate: json['depDate'] as String?,
  depTime: json['depTime'] as String?,
  arrDate: json['arrDate'] as String?,
  arrTime: json['arrTime'] as String?,
);

Map<String, dynamic> _$QuotationFlightSegmentDtoToJson(
  _QuotationFlightSegmentDto instance,
) => <String, dynamic>{
  'airline': instance.airline,
  'flightNo': instance.flightNo,
  'class': instance.cabinClass,
  'from': instance.from,
  'to': instance.to,
  'depDate': instance.depDate,
  'depTime': instance.depTime,
  'arrDate': instance.arrDate,
  'arrTime': instance.arrTime,
};

_QuotationSightseeingBlockDto _$QuotationSightseeingBlockDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationSightseeingBlockDto(
  included: json['included'] as bool?,
  title: json['title'] as String?,
  amount: json['amount'] as num?,
  days:
      (json['days'] as List<dynamic>?)
          ?.map(
            (e) =>
                QuotationSightseeingDayDto.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <QuotationSightseeingDayDto>[],
);

Map<String, dynamic> _$QuotationSightseeingBlockDtoToJson(
  _QuotationSightseeingBlockDto instance,
) => <String, dynamic>{
  'included': instance.included,
  'title': instance.title,
  'amount': instance.amount,
  'days': instance.days,
};

_QuotationSightseeingDayDto _$QuotationSightseeingDayDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationSightseeingDayDto(
  day: (json['day'] as num?)?.toInt(),
  date: json['date'] as String?,
  pax: (json['pax'] as num?)?.toInt(),
  pricePerPax: json['pricePerPax'] as num?,
  activities:
      (json['activities'] as List<dynamic>?)
          ?.map((e) => QuotationActivityDto.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <QuotationActivityDto>[],
);

Map<String, dynamic> _$QuotationSightseeingDayDtoToJson(
  _QuotationSightseeingDayDto instance,
) => <String, dynamic>{
  'day': instance.day,
  'date': instance.date,
  'pax': instance.pax,
  'pricePerPax': instance.pricePerPax,
  'activities': instance.activities,
};

_QuotationActivityDto _$QuotationActivityDtoFromJson(
  Map<String, dynamic> json,
) => _QuotationActivityDto(
  attraction: json['attraction'] as String?,
  startTime: json['startTime'] as String?,
  description: json['description'] as String?,
  transfer: json['transfer'] as String?,
);

Map<String, dynamic> _$QuotationActivityDtoToJson(
  _QuotationActivityDto instance,
) => <String, dynamic>{
  'attraction': instance.attraction,
  'startTime': instance.startTime,
  'description': instance.description,
  'transfer': instance.transfer,
};
