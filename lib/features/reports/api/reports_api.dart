import 'package:dio/dio.dart';

import '../../../domain/entities/analytics.dart';
import '../../../data/dto/envelopes.dart';
import '../../../data/remote/failure_mapper.dart';

/// `DashboardAnalyticsController` — `GET /api/dashboard/analytics`.
///
/// One endpoint backs the whole Reports screen: KPIs, revenue timeline, lead
/// sources, top destinations and agent performance. Requires CRM_FULL, so a
/// sub-agent gets 403 and the screen says so rather than showing zeroes.
class ReportsApi {
  const ReportsApi(this._dio);

  final Dio _dio;

  /// [period] is one of `today|week|month|quarter|year|custom`.
  Future<Analytics> getAnalytics({String period = 'month'}) async {
    try {
      final response = await _dio.get<dynamic>(
        '/api/dashboard/analytics',
        queryParameters: {'period': period},
      );

      final envelope = ApiEnvelope.from<Analytics>(
        response.data,
        (data) => _toAnalytics(data! as Map<String, dynamic>),
      );
      return envelope.requireData();
    } on DioException catch (e) {
      throw FailureMapper.from(e);
    }
  }

  static Analytics _toAnalytics(Map<String, dynamic> json) => Analytics(
        totalLeads: (json['totalLeads'] as num?)?.toInt() ?? 0,
        convertedLeads: (json['convertedLeads'] as num?)?.toInt() ?? 0,
        conversionRate: (json['conversionRate'] as num?)?.toDouble() ?? 0,
        hotLeads: (json['hotLeads'] as num?)?.toInt() ?? 0,
        winRate: (json['winRate'] as num?)?.toDouble() ?? 0,
        revenue: (json['revenue'] as num?)?.toDouble() ?? 0,
        agencyRevenue: (json['agencyRevenue'] as num?)?.toDouble() ?? 0,
        // Profit fields are permission-gated; null means "not permitted to
        // see", which the screen must not render as zero.
        profit: (json['profit'] as num?)?.toDouble(),
        totalProfit: (json['totalProfit'] as num?)?.toDouble(),
        netMargin: (json['netMargin'] as num?)?.toDouble(),
        refunds: (json['refunds'] as num?)?.toDouble() ?? 0,
        leadSources: _list(json['leadSources'])
            .map(
              (e) => NamedValue(
                name: e['name'] as String? ?? '—',
                value: (e['value'] as num?)?.toDouble() ?? 0,
              ),
            )
            .toList(growable: false),
        topDestinations: _list(json['topDestinations'])
            .map(
              (e) => DestinationStat(
                name: e['name'] as String? ?? '—',
                bookings: (e['bookings'] as num?)?.toInt() ?? 0,
                revenue: (e['revenue'] as num?)?.toDouble() ?? 0,
              ),
            )
            .toList(growable: false),
        revenueTimeline: _list(json['revenueTimeline'])
            .map(
              (e) => TimelinePoint(
                label: e['month'] as String? ?? '',
                revenue: (e['revenue'] as num?)?.toDouble() ?? 0,
                bookings: (e['bookings'] as num?)?.toInt() ?? 0,
              ),
            )
            .toList(growable: false),
        topPerformers: _list(json['topPerformersConv'])
            .map(
              (e) => AgentStat(
                name: e['name'] as String? ?? '—',
                leads: (e['leads'] as num?)?.toInt() ?? 0,
                conversions: (e['conversions'] as num?)?.toInt() ?? 0,
                revenue: (e['revenue'] as num?)?.toDouble() ?? 0,
                rate: (e['rate'] as num?)?.toDouble() ?? 0,
              ),
            )
            .toList(growable: false),
      );

  static List<Map<String, dynamic>> _list(Object? value) => value is List
      ? value.whereType<Map<String, dynamic>>().toList(growable: false)
      : const [];
}
