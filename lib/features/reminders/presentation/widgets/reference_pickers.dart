import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/formatters/phone.dart';
import '../../../../core/icons/app_icon.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/lead.dart';
import '../../../../domain/repositories/lead_repository.dart';
import '../../../../widgets/state_views.dart';
import '../../../leads/leads.dart' show assignmentChoiceProvider;

/// What a picker hands back: the UUID to send, and the name to show.
///
/// Kept together because the two must not drift — the id is what the server
/// resolves and the label is what the agent recognises, and a form that shows
/// one while sending the other is the vendor-picker bug all over again.
typedef PickedReference = ({String id, String name});

/// The search text behind the lead picker, debounced.
///
/// `/api/leads` narrows server-side, so a request per keystroke would be a
/// request per keystroke — the same reason the vendors list debounces.
final _leadQueryProvider =
    NotifierProvider.autoDispose<_LeadQueryNotifier, String?>(
  _LeadQueryNotifier.new,
);

class _LeadQueryNotifier extends Notifier<String?> {
  Timer? _debounce;

  @override
  String? build() {
    ref.onDispose(() => _debounce?.cancel());
    return null;
  }

  void search(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final trimmed = query.trim();
      state = trimmed.isEmpty ? null : trimmed;
    });
  }
}

/// One page of leads matching the current search.
///
/// Deliberately small: this is a picker, not the leads screen. An agent who
/// cannot find the lead in twenty results should type more, not scroll.
final _leadChoicesProvider = FutureProvider.autoDispose<List<Lead>>((ref) async {
  final page = await ref.watch(leadRepositoryProvider).getLeads(
        size: 20,
        filter: LeadFilter(search: ref.watch(_leadQueryProvider)),
      );
  return page.leads;
});

/// Pick the lead a reminder hangs off.
class LeadPickerSheet extends ConsumerStatefulWidget {
  const LeadPickerSheet._();

  /// Returns the chosen lead, or null when dismissed.
  static Future<PickedReference?> show(BuildContext context) =>
      showModalBottomSheet<PickedReference>(
        context: context,
        isScrollControlled: true,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const LeadPickerSheet._(),
        ),
      );

  @override
  ConsumerState<LeadPickerSheet> createState() => _LeadPickerSheetState();
}

class _LeadPickerSheetState extends ConsumerState<LeadPickerSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(_leadChoicesProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x12,
          AppSpacing.x16,
          AppSpacing.x16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Grip(),
            const SizedBox(height: AppSpacing.x16),
            Text('Link to a lead', style: AppType.h3),
            const SizedBox(height: AppSpacing.x12),
            SizedBox(
              height: 42,
              child: TextField(
                controller: _controller,
                autofocus: true,
                onChanged: (q) =>
                    ref.read(_leadQueryProvider.notifier).search(q),
                style: AppType.fieldValue,
                cursorColor: AppColors.primary,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search name or phone',
                  fillColor: AppColors.canvas,
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.x12,
                      right: AppSpacing.x8,
                    ),
                    child: AppIcon(Ic.search, size: 18, color: AppColors.faint),
                  ),
                  prefixIconConstraints:
                      BoxConstraints(minWidth: 0, minHeight: 0),
                  border: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadii.rTile,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.x8),
            SizedBox(
              height: 320,
              child: switch (async) {
                AsyncLoading() => const SkeletonList(itemCount: 4, itemHeight: 56),
                AsyncError(:final error) => ErrorStateView(
                    failure: asFailure(error),
                    onRetry: () => ref.invalidate(_leadChoicesProvider),
                  ),
                AsyncData(:final value) when value.isEmpty => Center(
                    child: Text('No lead matches that.', style: AppType.bodySm),
                  ),
                AsyncData(:final value) => ListView.separated(
                    itemCount: value.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, color: AppColors.line),
                    itemBuilder: (context, index) {
                      final lead = value[index];
                      return _Row(
                        title: lead.customerName.isEmpty
                            ? 'Unnamed lead'
                            : lead.customerName,
                        subtitle: [
                          if (lead.phone.isNotEmpty) Phone.display(lead.phone),
                          if (lead.leadCode != null) lead.leadCode!,
                        ].join(' · '),
                        onTap: () => Navigator.of(context).pop(
                          (id: lead.id, name: lead.customerName),
                        ),
                      );
                    },
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Pick who a reminder belongs to.
///
/// The list is the lead module's assignment recommendation — the same set of
/// users the server will accept, already loaded elsewhere in the app, rather
/// than a second user-listing endpoint this client does not have.
class AssigneePickerSheet extends ConsumerWidget {
  const AssigneePickerSheet._();

  static Future<PickedReference?> show(BuildContext context) =>
      showModalBottomSheet<PickedReference>(
        context: context,
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
        builder: (_) => const AssigneePickerSheet._(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(assignmentChoiceProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x16,
          AppSpacing.x12,
          AppSpacing.x16,
          AppSpacing.x16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Grip(),
            const SizedBox(height: AppSpacing.x16),
            Text('Assign to', style: AppType.h3),
            const SizedBox(height: AppSpacing.x8),
            switch (async) {
              AsyncLoading() =>
                const SkeletonList(itemCount: 3, itemHeight: 56, shrinkWrap: true),
              AsyncError(:final error) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.x16),
                  child: Text(
                    asFailure(error).message,
                    style: AppType.bodySm.copyWith(color: AppColors.danger),
                  ),
                ),
              AsyncData(:final value) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final user in value.eligibleUsers)
                      _Row(
                        title: user.name,
                        subtitle: [
                          if (user.id == value.recommendedUserId) 'Suggested',
                          if (user.activeLeads != null)
                            '${user.activeLeads} active leads',
                        ].join(' · '),
                        onTap: () => Navigator.of(context)
                            .pop((id: user.id, name: user.name)),
                      ),
                  ],
                ),
            },
          ],
        ),
      ),
    );
  }
}

class _Grip extends StatelessWidget {
  const _Grip();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppRadii.pill),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppType.body, maxLines: 1, overflow: TextOverflow.ellipsis),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.x2),
              Text(subtitle, style: AppType.caption, maxLines: 1),
            ],
          ],
        ),
      ),
    );
  }
}
