import 'package:flutter/foundation.dart';

import 'quotation_enums.dart';

/// A quotation row, mapped from `QuotationSummaryDto`.
@immutable
class QuotationSummary {
  const QuotationSummary({
    required this.id,
    this.leadId,
    this.title,
    this.version,
    this.pdfUrl,
    required this.templateStyle,
    this.stage,
    required this.customerName,
    this.destination,
    this.travelDate,
    required this.grandTotal,
    this.createdAt,
  });

  final String id;
  final String? leadId;
  final String? title;
  final int? version;

  /// Server-rendered PDF, when one has been generated.
  final String? pdfUrl;

  final TemplateStyle templateStyle;
  final QuotationStage? stage;

  final String customerName;
  final String? destination;
  final DateTime? travelDate;

  /// Server-computed total — the app never sums a quotation.
  final double grandTotal;

  final DateTime? createdAt;

  String get displayTitle {
    final t = title?.trim();
    if (t != null && t.isNotEmpty) return t;
    return destination?.trim().isNotEmpty ?? false ? destination! : 'Quotation';
  }

  @override
  bool operator ==(Object other) => other is QuotationSummary && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// The full quotation, for the preview screen.
@immutable
class Quotation {
  const Quotation({
    required this.id,
    this.leadId,
    this.title,
    this.quoteNo,
    this.version,
    this.pdfUrl,
    this.stage,
    required this.templateStyle,
    this.notes,
    this.nights,
    this.days,
    this.rooms,
    this.customer,
    this.totals,
    this.hotels = const [],
    this.vehicles = const [],
    this.flights = const [],
    this.dayPlan = const [],
    this.inclusions = const [],
    this.exclusions = const [],
    this.paymentPolicies = const [],
    this.cancellationPolicies = const [],
    this.bookingTerms = const [],
    this.createdBy,
    this.createdAt,
  });

  final String id;
  final String? leadId;
  final String? title;

  /// Human reference printed on the document.
  final String? quoteNo;

  final int? version;
  final String? pdfUrl;
  final QuotationStage? stage;
  final TemplateStyle templateStyle;
  final String? notes;

  final int? nights;
  final int? days;
  final int? rooms;

  final QuotationCustomer? customer;
  final QuotationTotals? totals;

  /// Service blocks. A block the builder switched off arrives with an empty
  /// list, so an empty list means "not quoted" rather than "not sent".
  final List<QuotationStay> hotels;
  final List<QuotationTransport> vehicles;
  final List<QuotationFlightLeg> flights;

  /// The day-wise plan, from the sightseeing block.
  final List<QuotationDay> dayPlan;

  final List<String> inclusions;
  final List<String> exclusions;
  final List<String> paymentPolicies;
  final List<String> cancellationPolicies;
  final List<String> bookingTerms;

  final String? createdBy;
  final DateTime? createdAt;

  /// `6N / 7D` when the server supplies both.
  String? get durationLabel {
    if (nights == null && days == null) return null;
    if (nights != null && days != null) return '${nights}N / ${days}D';
    return nights != null ? '${nights}N' : '${days}D';
  }
}

@immutable
class QuotationCustomer {
  const QuotationCustomer({
    this.name,
    this.phone,
    this.email,
    this.destination,
    this.travelDate,
    this.adults,
    this.children,
    this.infants,
  });

  final String? name;
  final String? phone;
  final String? email;
  final String? destination;
  final DateTime? travelDate;
  final int? adults;
  final int? children;
  final int? infants;

  String get paxLabel {
    final parts = <String>[
      if ((adults ?? 0) > 0) '${adults}A',
      if ((children ?? 0) > 0) '${children}C',
      if ((infants ?? 0) > 0) '${infants}I',
    ];
    return parts.isEmpty ? '—' : parts.join(' ');
  }
}

/// The price break-up, exactly as the server computed it. Nothing here is
/// recalculated client-side — tax and discount rules live on the backend.
@immutable
class QuotationTotals {
  const QuotationTotals({
    required this.subtotal,
    this.discountType,
    required this.discount,
    required this.discountAmount,
    required this.markup,
    required this.taxPercent,
    required this.taxAmount,
    required this.grandTotal,
    required this.addonsTotal,
    this.perAdult,
  });

  final double subtotal;

  /// `%` or `Fixed`.
  final String? discountType;

  final double discount;
  final double discountAmount;
  final double markup;
  final double taxPercent;
  final double taxAmount;
  final double grandTotal;
  final double addonsTotal;
  final double? perAdult;
}

/// One hotel stay on the quotation.
@immutable
class QuotationStay {
  const QuotationStay({
    required this.name,
    this.city,
    this.checkIn,
    this.checkOut,
    this.roomType,
    this.mealPlan,
    this.stars,
    this.rooms,
    this.pricePerRoom,
  });

  final String name;
  final String? city;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? roomType;
  final String? mealPlan;
  final int? stars;
  final int? rooms;
  final double? pricePerRoom;

  /// Nights derived from the stay's own dates — not from the quotation total,
  /// which spans every stay.
  int? get nights {
    final a = checkIn;
    final b = checkOut;
    if (a == null || b == null) return null;
    final n = b.difference(DateTime(a.year, a.month, a.day)).inDays;
    return n > 0 ? n : null;
  }
}

/// One vehicle leg.
@immutable
class QuotationTransport {
  const QuotationTransport({
    this.type,
    this.model,
    this.pickup,
    this.drop,
    this.startDate,
    this.endDate,
    this.qty,
    this.pricePerVehicle,
  });

  final String? type;
  final String? model;
  final String? pickup;
  final String? drop;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? qty;
  final double? pricePerVehicle;

  /// `SUV · 6seater`, or whichever half the builder filled in.
  String get label {
    final parts = [type, model].where((p) => p != null && p.trim().isNotEmpty);
    return parts.isEmpty ? 'Vehicle' : parts.join(' · ');
  }

  /// `Kaski → mumbai`, when both ends are known.
  String? get route {
    final a = pickup?.trim();
    final b = drop?.trim();
    if (a == null || a.isEmpty || b == null || b.isEmpty) return null;
    return '$a → $b';
  }
}

/// One flight segment.
@immutable
class QuotationFlightLeg {
  const QuotationFlightLeg({
    this.airline,
    this.flightNo,
    this.cabinClass,
    this.from,
    this.to,
    this.departure,
    this.departureTime,
  });

  final String? airline;
  final String? flightNo;
  final String? cabinClass;
  final String? from;
  final String? to;
  final DateTime? departure;
  final String? departureTime;

  String? get route {
    final a = from?.trim();
    final b = to?.trim();
    if (b == null || b.isEmpty) return null;
    return (a == null || a.isEmpty) ? b : '$a → $b';
  }

  /// `6E 5343`, or whichever half the builder filled in.
  String? get carrier {
    final parts = [airline, flightNo].where((p) => p != null && p.trim().isNotEmpty);
    return parts.isEmpty ? null : parts.join(' ');
  }
}

/// One day of the plan.
@immutable
class QuotationDay {
  const QuotationDay({
    required this.day,
    this.date,
    this.activities = const [],
  });

  final int day;
  final DateTime? date;
  final List<QuotationActivity> activities;
}

@immutable
class QuotationActivity {
  const QuotationActivity({
    required this.attraction,
    this.description,
    this.startTime,
    this.transfer,
  });

  final String attraction;
  final String? description;
  final String? startTime;
  final String? transfer;
}
