import 'package:flutter/foundation.dart';

import 'lead_enums.dart';

/// A lead, as the app understands it — mapped from the running backend's
/// `LeadResponseDto`: dates parsed, enums resolved, nulls defaulted. Screens
/// use only this, never `LeadDto`.
@immutable
class Lead {
  const Lead({
    required this.id,
    this.leadCode,
    required this.customerName,
    required this.phone,
    this.email,
    this.whatsapp,
    this.city,
    this.state,
    this.country,
    this.source,
    this.type,
    this.stage,
    this.assignedTo,
    this.birthDate,
    this.followUpDate,
    this.travelDate,
    this.returnDate,
    this.budget,
    this.logCount = 0,
    this.lastActivityAt,
    this.departCountry,
    this.departCity,
    this.rooms,
    this.adults,
    this.children,
    this.infants,
    this.extraBeds,
    this.services = const [],
    this.notes,
    this.itinerary = const [],
    this.createdAt,
    this.latestQuotationTotal,
    this.convertedBookingId,
    this.openToClaim = false,
  });

  /// Public UUID — the only identifier the API exposes.
  final String id;

  /// Human reference like `LD-2418`.
  final String? leadCode;

  final String customerName;
  final String phone;
  final String? email;
  final String? whatsapp;
  final String? city;
  final String? state;
  final String? country;

  /// Display name straight from the wire ("Google Ads", "JustDial", …).
  /// Not an enum — the server owns this vocabulary (25 values and growing).
  final String? source;

  /// Drives the priority chip (Fresh / Hot / Warm / Cold).
  final LeadType? type;
  final LeadStage? stage;

  /// The owning agent — every lead has one on this backend.
  final AssignedAgent? assignedTo;

  final DateTime? birthDate;
  final DateTime? followUpDate;
  final DateTime? travelDate;
  final DateTime? returnDate;

  /// Approximate budget in INR.
  final double? budget;

  /// Number of activity-log entries (follow-up history).
  final int logCount;
  final DateTime? lastActivityAt;

  final String? departCountry;
  final String? departCity;

  final int? rooms;
  final int? adults;
  final int? children;
  final int? infants;
  final int? extraBeds;

  final List<String> services;
  final String? notes;
  final List<LeadItineraryStop> itinerary;
  final DateTime? createdAt;

  /// Grand total of the latest quotation, when one exists.
  final double? latestQuotationTotal;

  /// Set once the lead is converted.
  final String? convertedBookingId;

  final bool openToClaim;

  /// Initials for the avatar, e.g. "Rahul Sharma" → "RS".
  String get initials {
    final parts = customerName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, parts.first.length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  int get totalPax => (adults ?? 0) + (children ?? 0) + (infants ?? 0);

  /// `4A 2C` / `2A` — the prototype's compact pax label.
  String get paxLabel {
    final parts = <String>[
      if ((adults ?? 0) > 0) '${adults}A',
      if ((children ?? 0) > 0) '${children}C',
      if ((infants ?? 0) > 0) '${infants}I',
    ];
    return parts.isEmpty ? '—' : parts.join(' ');
  }

  /// `Nepal · Kathmandu & Pokhara`, built from the itinerary stops.
  String get destinationLabel {
    if (itinerary.isEmpty) return departCity ?? departCountry ?? '—';
    final destinations = itinerary.map((s) => s.destination).where((d) => d.isNotEmpty).toSet();
    final cities = itinerary.map((s) => s.city).where((c) => c.isNotEmpty).toList();
    final head = destinations.join(' / ');
    if (cities.isEmpty) return head;
    return '$head · ${cities.join(' & ')}';
  }

  /// `6N / 7D`, summed from itinerary nights (days = nights + 1).
  String? get nightsLabel {
    if (itinerary.isEmpty) return null;
    final nights = itinerary.fold<int>(0, (sum, s) => sum + s.nights);
    if (nights <= 0) return null;
    return '${nights}N / ${nights + 1}D';
  }

  @override
  bool operator ==(Object other) => other is Lead && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

/// The lead's owner, from `LeadResponseDto.assignedUser`.
@immutable
class AssignedAgent {
  const AssignedAgent({required this.id, required this.name, this.role, this.email});

  final String id;
  final String name;
  final String? role;
  final String? email;
}

/// One stop in the lead's requirement itinerary.
@immutable
class LeadItineraryStop {
  const LeadItineraryStop({
    this.id,
    required this.destination,
    required this.city,
    required this.nights,
    this.destinationId,
  });

  /// The stop's public UUID.
  final String? id;
  final String destination;
  final String city;
  final int nights;

  /// The destination this stop sits under, when the server sent it. Used to
  /// narrow the hotel and sightseeing masters when quoting for this lead.
  final int? destinationId;
}

/// One activity-log entry (`LeadLogResponseDto`) — the follow-up timeline.
@immutable
class LeadLog {
  const LeadLog({
    required this.id,
    required this.comment,
    this.stage,
    this.followUpDate,
    this.addedBy,
    this.createdAt,
  });

  final String id;
  final String comment;
  final LeadStage? stage;
  final DateTime? followUpDate;
  final String? addedBy;
  final DateTime? createdAt;
}

/// `GET /api/leads/stats/summary` — the dashboard's lead roll-up.
@immutable
class LeadStats {
  const LeadStats({
    required this.totalLeads,
    required this.activeLeads,
    required this.convertedLeads,
    required this.lostLeads,
    required this.proposalSentLeads,
    required this.byStage,
    required this.byType,
    required this.activePipelineValue,
    required this.quotedValue,
    required this.followUpsOverdue,
    required this.followUpsDueToday,
    required this.createdInPeriod,
    required this.convertedInPeriod,
    this.conversionRate,
  });

  final int totalLeads;
  final int activeLeads;
  final int convertedLeads;
  final int lostLeads;
  final int proposalSentLeads;

  /// Count per stage, zero-filled in enum order by the server.
  final Map<LeadStage, int> byStage;
  final Map<LeadType, int> byType;

  final double activePipelineValue;
  final double quotedValue;
  final int followUpsOverdue;
  final int followUpsDueToday;
  final int createdInPeriod;
  final int convertedInPeriod;

  /// Percent; null when nothing was created in the period (≠ 0).
  final double? conversionRate;

  int get hotLeads => byType[LeadType.hot] ?? 0;
}

/// A user who can be assigned a lead, plus the server's recommendation.
@immutable
class AssignmentChoice {
  const AssignmentChoice({
    required this.forcedSelf,
    this.self,
    this.recommendedUserId,
    required this.eligibleUsers,
    this.strategyLabel,
  });

  final bool forcedSelf;
  final EligibleAgent? self;
  final String? recommendedUserId;
  final List<EligibleAgent> eligibleUsers;
  final String? strategyLabel;
}

@immutable
class EligibleAgent {
  const EligibleAgent({required this.id, required this.name, this.activeLeads});

  final String id;
  final String name;
  final int? activeLeads;
}
