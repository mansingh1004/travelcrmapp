import 'package:flutter/widgets.dart';

import '../../domain/entities/booking_enums.dart';
import '../../data/services/communication_api.dart';
import '../../domain/entities/calendar.dart';
import '../../domain/entities/customer_enums.dart';
import '../../domain/entities/lead_enums.dart';
import '../../domain/entities/operations_enums.dart';
import '../../domain/entities/quotation_enums.dart';
import '../theme/app_colors.dart';

/// A foreground/background colour pair for a status chip.
@immutable
class StatusPalette {
  const StatusPalette(this.foreground, this.background);

  final Color foreground;
  final Color background;
}

/// The single status→colour map for the whole app, per the spec's
/// "STATUS COLOR MAP (use everywhere)".
///
/// Stage colours come from the prototype's `STAGE` object, mapped onto the
/// backend's eight real stages.
abstract final class StatusColors {
  static StatusPalette stage(LeadStage stage) => switch (stage) {
        LeadStage.newLead => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        LeadStage.contacted => const StatusPalette(AppColors.purple, AppColors.purpleBg),
        LeadStage.followUp => const StatusPalette(AppColors.amber, AppColors.amberBg),
        LeadStage.qualified => const StatusPalette(AppColors.teal, AppColors.tealBg),
        LeadStage.proposalSent => const StatusPalette(AppColors.warn, AppColors.warnBg),
        LeadStage.converted => const StatusPalette(AppColors.success, AppColors.successBg),
        LeadStage.reopened => const StatusPalette(AppColors.primaryDark, AppColors.primaryTint),
        LeadStage.lost => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };

  /// Priority chip, driven by `LeadType`.
  static StatusPalette priority(LeadType type) => switch (type) {
        LeadType.hot => const StatusPalette(AppColors.danger, AppColors.dangerBg),
        LeadType.warm => const StatusPalette(AppColors.warn, AppColors.warnBg),
        LeadType.cold => const StatusPalette(AppColors.slate, AppColors.slateBg),
        LeadType.fresh => const StatusPalette(AppColors.primary, AppColors.primaryTint),
      };

  /// Neutral chip, for values with no semantic colour (e.g. lead source).
  static const neutral = StatusPalette(AppColors.slate, AppColors.slateBg);

  static StatusPalette customerStatus(CustomerStatus status) => switch (status) {
        CustomerStatus.active => const StatusPalette(AppColors.success, AppColors.successBg),
        CustomerStatus.inactive => const StatusPalette(AppColors.slate, AppColors.slateBg),
        CustomerStatus.blocked => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };

  /// Loyalty tier. Bronze/Silver/Gold/Platinum read as a ladder, so the colours
  /// climb with them rather than being arbitrary.
  static StatusPalette tier(LoyaltyTier tier) => switch (tier) {
        LoyaltyTier.bronze => const StatusPalette(AppColors.warn, AppColors.warnBg),
        LoyaltyTier.silver => const StatusPalette(AppColors.slate, AppColors.slateBg),
        LoyaltyTier.gold => const StatusPalette(AppColors.amber, AppColors.amberBg),
        LoyaltyTier.platinum => const StatusPalette(AppColors.purple, AppColors.purpleBg),
      };

  /// VIP and Corporate are the two that deserve to stand out in a list.
  static StatusPalette customerType(CustomerType type) => switch (type) {
        CustomerType.vip => const StatusPalette(AppColors.purple, AppColors.purpleBg),
        CustomerType.corporate => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        CustomerType.agent => const StatusPalette(AppColors.teal, AppColors.tealBg),
        _ => neutral,
      };

  // ── Maps kept for screens whose backend does not exist yet ─────────────
  // These are colour definitions only, not data. They are declared here so the
  // map stays in one place for when the corresponding endpoints land.

  static StatusPalette quotationStage(QuotationStage stage) => switch (stage) {
        QuotationStage.draft => const StatusPalette(AppColors.amber, AppColors.amberBg),
        QuotationStage.sent => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        QuotationStage.approved =>
          const StatusPalette(AppColors.success, AppColors.successBg),
        QuotationStage.rejected => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };

  static StatusPalette bookingStatus(BookingStatus status) => switch (status) {
        BookingStatus.confirmed => const StatusPalette(AppColors.success, AppColors.successBg),
        BookingStatus.pending => const StatusPalette(AppColors.warn, AppColors.warnBg),
        BookingStatus.completed => const StatusPalette(AppColors.slate, AppColors.slateBg),
        BookingStatus.cancelled => const StatusPalette(AppColors.danger, AppColors.dangerBg),
        BookingStatus.refunded => const StatusPalette(AppColors.purple, AppColors.purpleBg),
      };

  static StatusPalette paymentStatus(PaymentStatus status) => switch (status) {
        PaymentStatus.paid => const StatusPalette(AppColors.success, AppColors.successBg),
        PaymentStatus.partial => const StatusPalette(AppColors.warn, AppColors.warnBg),
        PaymentStatus.unpaid => const StatusPalette(AppColors.danger, AppColors.dangerBg),
        PaymentStatus.refunded => const StatusPalette(AppColors.purple, AppColors.purpleBg),
      };

  /// Communication channel → colour, so a WhatsApp thread is distinguishable
  /// from an email one at a glance.
  static StatusPalette commChannel(CommChannel channel) => switch (channel) {
        CommChannel.whatsapp => const StatusPalette(AppColors.success, AppColors.successBg),
        CommChannel.email => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        CommChannel.sms => const StatusPalette(AppColors.teal, AppColors.tealBg),
        CommChannel.call => const StatusPalette(AppColors.purple, AppColors.purpleBg),
        CommChannel.internalChat ||
        CommChannel.internalNote =>
          const StatusPalette(AppColors.amber, AppColors.amberBg),
      };

  /// Calendar source → colour. Doubles as the legend and the day-dot palette,
  /// so the two can never drift apart.
  static StatusPalette calendarSource(CalendarSource source) => switch (source) {
        CalendarSource.reminder => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        CalendarSource.task => const StatusPalette(AppColors.purple, AppColors.purpleBg),
        CalendarSource.trip => const StatusPalette(AppColors.success, AppColors.successBg),
        CalendarSource.paymentDue => const StatusPalette(AppColors.warn, AppColors.warnBg),
        CalendarSource.flight => const StatusPalette(AppColors.teal, AppColors.tealBg),
        CalendarSource.hotelCheckin => const StatusPalette(AppColors.amber, AppColors.amberBg),
        CalendarSource.visa => const StatusPalette(AppColors.slate, AppColors.slateBg),
      };

  /// The operations board's headline state per booking.
  static StatusPalette opsOverall(OpsOverallStatus status) => switch (status) {
        OpsOverallStatus.ready => const StatusPalette(AppColors.success, AppColors.successBg),
        OpsOverallStatus.actionNeeded =>
          const StatusPalette(AppColors.warn, AppColors.warnBg),
        OpsOverallStatus.urgent => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };

  /// One readiness dimension on a board row.
  static StatusPalette opsReadiness(OpsReadinessStatus status) => switch (status) {
        OpsReadinessStatus.ready => const StatusPalette(AppColors.success, AppColors.successBg),
        OpsReadinessStatus.inProgress => const StatusPalette(AppColors.warn, AppColors.warnBg),
        OpsReadinessStatus.notStarted => const StatusPalette(AppColors.danger, AppColors.dangerBg),
        OpsReadinessStatus.notApplicable => neutral,
      };

  /// How close a booking is to breaking, as the server graded it.
  static StatusPalette opsSeverity(OpsSeverity severity) => switch (severity) {
        OpsSeverity.none => const StatusPalette(AppColors.success, AppColors.successBg),
        OpsSeverity.watch => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        OpsSeverity.warning => const StatusPalette(AppColors.warn, AppColors.warnBg),
        OpsSeverity.critical => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };

  /// One of the nine checkpoints on a booking.
  static StatusPalette opsCheckpoint(OpsCheckpointStatus status) => switch (status) {
        OpsCheckpointStatus.confirmed =>
          const StatusPalette(AppColors.success, AppColors.successBg),
        OpsCheckpointStatus.requested =>
          const StatusPalette(AppColors.primary, AppColors.primaryTint),
        OpsCheckpointStatus.pending => const StatusPalette(AppColors.warn, AppColors.warnBg),
        OpsCheckpointStatus.rejected ||
        OpsCheckpointStatus.expired ||
        OpsCheckpointStatus.blocked =>
          const StatusPalette(AppColors.danger, AppColors.dangerBg),
        OpsCheckpointStatus.notApplicable => neutral,
      };

  /// Per-service confirmation state on a booking.
  static StatusPalette serviceStatus(ServiceItemStatus status) => switch (status) {
        ServiceItemStatus.confirmed =>
          const StatusPalette(AppColors.success, AppColors.successBg),
        ServiceItemStatus.requested => const StatusPalette(AppColors.primary, AppColors.primaryTint),
        ServiceItemStatus.pending => const StatusPalette(AppColors.warn, AppColors.warnBg),
        ServiceItemStatus.cancelled => const StatusPalette(AppColors.danger, AppColors.dangerBg),
      };
}
