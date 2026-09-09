import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../router/safe_pop.dart';
import '../../../widgets/state_views.dart';
import '../providers/lead_detail_provider.dart';
import 'lead_create_screen.dart';

/// `/leads/:id/edit` — loads the lead, then hands it to the add-lead form.
///
/// A route rather than a push with the object in hand, so the edit survives a
/// deep link and a process restart the way every other detail route does. The
/// screen itself is [LeadCreateScreen]: `PUT /api/leads/{publicId}` takes the
/// create DTO and assigns every field, so the form that creates a lead is the
/// only one that can safely edit one.
///
/// The lead is usually already cached by the detail screen this was opened
/// from, so the spinner below is the cold-start case — a deep link straight
/// into the editor.
class LeadEditScreen extends ConsumerWidget {
  const LeadEditScreen({super.key, required this.publicId});

  final String publicId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(leadDetailProvider(publicId));

    return switch (async) {
      AsyncData(:final value) => LeadCreateScreen(lead: value),
      _ => Scaffold(
          backgroundColor: AppColors.canvas,
          appBar: AppBar(
            leading: IconButton(
              onPressed: context.backOrHome,
              icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
              tooltip: 'Back',
            ),
            title: Text('Edit lead', style: AppType.h2),
            shape: const Border(bottom: BorderSide(color: AppColors.line)),
          ),
          body: switch (async) {
            AsyncError(:final error) => ErrorStateView(
                failure: asFailure(error),
                onRetry: () => ref.invalidate(leadDetailProvider(publicId)),
              ),
            // A half-filled form is worse than a spinner: the fields would show
            // their own defaults, and this form posts every field back.
            _ => const Center(child: CircularProgressIndicator()),
          },
        ),
    };
  }
}
