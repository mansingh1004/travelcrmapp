import 'package:flutter/foundation.dart';

/// `GET /api/dashboard/analytics` — the whole Reports screen in one payload.
///
/// Every figure is server-computed. Profit fields are permission-gated and
/// arrive null when the caller lacks `BOOKING_PROFIT_READ`; null means
/// "not permitted to see", which is different from zero and is rendered as an
/// omitted card rather than a ₹0.
@immutable
class Analytics {
  const Analytics({
    required this.totalLeads,
    required this.convertedLeads,
    required this.conversionRate,
    required this.hotLeads,
    required this.winRate,
    required this.revenue,
    required this.agencyRevenue,
    this.profit,
    this.totalProfit,
    this.netMargin,
    required this.refunds,
    required this.leadSources,
    required this.topDestinations,
    required this.revenueTimeline,
    required this.topPerformers,
  });

  final int totalLeads;
  final int convertedLeads;
  final double conversionRate;
  final int hotLeads;
  final double winRate;

  /// Active bookings only — cancelled and refunded are excluded server-side.
  final double revenue;

  /// Revenue plus retained cancellation charges.
  final double agencyRevenue;

  final double? profit;
  final double? totalProfit;
  final double? netMargin;
  final double refunds;

  final List<NamedValue> leadSources;
  final List<DestinationStat> topDestinations;
  final List<TimelinePoint> revenueTimeline;
  final List<AgentStat> topPerformers;

  bool get canSeeProfit => profit != null || totalProfit != null;
}

@immutable
class NamedValue {
  const NamedValue({required this.name, required this.value});

  final String name;
  final double value;
}

@immutable
class DestinationStat {
  const DestinationStat({
    required this.name,
    required this.bookings,
    required this.revenue,
  });

  final String name;
  final int bookings;
  final double revenue;
}

@immutable
class TimelinePoint {
  const TimelinePoint({
    required this.label,
    required this.revenue,
    required this.bookings,
  });

  final String label;
  final double revenue;
  final int bookings;
}

@immutable
class AgentStat {
  const AgentStat({
    required this.name,
    required this.leads,
    required this.conversions,
    required this.revenue,
    required this.rate,
  });

  final String name;
  final int leads;
  final int conversions;
  final double revenue;

  /// Conversion percentage, as the server computed it.
  final double rate;
}
