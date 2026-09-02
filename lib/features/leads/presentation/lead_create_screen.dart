import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/formatters/app_date.dart';
import '../../../core/formatters/phone.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/mappers/lead_mapper.dart';
import '../../../data/services/task_api.dart';
import '../../../domain/entities/lead.dart';
import '../../../domain/entities/lead_enums.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_toast.dart';
import '../providers/leads_controller.dart';
import 'widgets/auth_style_field.dart';
import '../../../router/safe_pop.dart';

/// How the party is getting to the destination — `DepartureMode` on the wire.
enum _TravelMode {
  flight('FLIGHT', 'Flight'),
  train('TRAIN', 'Train'),
  car('CAR', 'Car'),
  bus('BUS', 'Bus'),
  other('OTHER', 'Other');

  const _TravelMode(this.wire, this.label);

  final String wire;
  final String label;
}

/// Create-lead wizard — the spec's five steps.
///
/// **Nothing on any step is required to move forward.** An enquiry arrives half
/// known: a name and a number on WhatsApp, the dates a week later. The wizard
/// therefore validates only when you press Save, and only the two fields the
/// server itself rejects without — `customerName` and `phone` — landing you
/// back on step 1 with the message rather than blocking you at step 1 in the
/// first place.
///
/// Four controls in the spec have no column on `POST /api/leads` and are left
/// out rather than faked: **alternate number**, **lead score**, a **reminder
/// offset** ("1 hour before"), and **notify on WhatsApp**. Where the spec pairs
/// the follow-up type with that reminder offset, this pairs it with the task's
/// own **priority** — a real setting, and the row keeps its shape.
///
/// "Save & create quotation" saves the lead and opens the quotation builder,
/// which is one of the shell's unbacked screens: it names the endpoint it is
/// waiting on instead of pretending to be ready.
///
/// The follow-up's **time** and **type** are stored as a task linked to the
/// lead (`POST /api/tasks`), because a lead's own `followUpDate` is a date with
/// no time on it.
class LeadCreateScreen extends ConsumerStatefulWidget {
  const LeadCreateScreen({super.key});

  @override
  ConsumerState<LeadCreateScreen> createState() => _LeadCreateScreenState();
}

class _LeadCreateScreenState extends ConsumerState<LeadCreateScreen> {
  static const _steps = ['Customer', 'Travellers', 'Travel', 'Lead info', 'Follow-up'];

  final _formKey = GlobalKey<FormState>();
  final _page = PageController();

  // Step 1 — customer. Two name fields, one `customerName` column.
  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _phone = TextEditingController();
  final _whatsapp = TextEditingController();
  final _email = TextEditingController();
  final _customerCity = TextEditingController();
  final _customerState = TextEditingController();
  final _customerCountry = TextEditingController(text: 'India');
  DateTime? _birthDate;

  // Step 2 — travellers
  int _adults = 1;
  int _male = 0;
  int _female = 0;
  int _children = 0;
  int _infants = 0;
  int _assistancePax = 0;
  int _rooms = 1;
  int _extraBeds = 0;
  bool _assistance = false;
  final _assistanceNotes = TextEditingController();

  // Step 3 — travel
  final _departCity = TextEditingController();
  final _destination = TextEditingController();
  final _city = TextEditingController();
  final _nights = TextEditingController();
  final _budget = TextEditingController();
  DateTime? _travelDate;
  DateTime? _returnDate;
  String _packageType = 'Family';
  _TravelMode _travelMode = _TravelMode.flight;

  static const _packageTypes = [
    'Family',
    'Couple',
    'Honeymoon',
    'Group',
    'Corporate',
    'Solo',
    'Pilgrimage',
    'Adventure',
  ];

  // Step 4 — lead info
  String? _source;
  LeadType _type = LeadType.fresh;
  LeadStage _stage = LeadStage.newLead;
  String? _assignedUserId;
  final _notes = TextEditingController();

  // Step 5 — first follow-up
  DateTime? _followUpDate;
  TimeOfDay _followUpTime = const TimeOfDay(hour: 10, minute: 0);
  TaskCategory _followUpType = TaskCategory.followUp;
  TaskPriority _followUpPriority = TaskPriority.medium;
  final _followUpNote = TextEditingController();

  int _index = 0;
  bool _busy = false;

  @override
  void dispose() {
    _page.dispose();
    for (final c in [
      _firstName,
      _lastName,
      _phone,
      _whatsapp,
      _email,
      _customerCity,
      _customerState,
      _customerCountry,
      _assistanceNotes,
      _departCity,
      _destination,
      _city,
      _nights,
      _budget,
      _notes,
      _followUpNote,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _customerName =>
      [_firstName.text.trim(), _lastName.text.trim()].where((p) => p.isNotEmpty).join(' ');

  /// Nights follow the date range when both ends are known; typed in by hand
  /// otherwise, for the enquiry that says "6 nights, dates flexible".
  void _syncNights() {
    final from = _travelDate;
    final to = _returnDate;
    if (from == null || to == null) return;
    final nights = to.difference(DateTime(from.year, from.month, from.day)).inDays;
    if (nights > 0) _nights.text = '$nights';
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _page.animateToPage(
      index,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _next() {
    if (_index == _steps.length - 1) {
      _submit();
      return;
    }
    _goTo(_index + 1);
  }

  void _back() {
    if (_index == 0) {
      context.backOrHome();
      return;
    }
    _goTo(_index - 1);
  }

  Future<void> _submit({bool thenQuotation = false}) async {
    // Checked against the controllers, not `Form.validate()`. A PageView keeps
    // only the visible page alive, so from step 5 the form has no idea step 1's
    // fields exist and would happily report an empty lead as valid.
    final missingName = _customerName.length < 2;
    final missingPhone = !Phone.isValid(_phone.text);
    if (missingName || missingPhone) {
      _goTo(0);
      // The page animation is 240ms and the fields only register with the form
      // on the frame after it settles, so validating any sooner marks nothing.
      await Future<void>.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      _formKey.currentState?.validate();
      AppToast.error(
        context,
        'Almost there',
        missingName && missingPhone
            ? 'A lead needs a name and a mobile number. Everything else can wait.'
            : missingName
                ? 'A lead needs a customer name.'
                : 'A lead needs a valid mobile number.',
      );
      return;
    }

    final assignee = _assignedUserId ??
        ref.read(assignmentChoiceProvider).value?.recommendedUserId ??
        ref.read(assignmentChoiceProvider).value?.self?.id;
    if (assignee == null) {
      AppToast.error(
        context,
        'No agent selected',
        'Pick who should own this lead on the Lead info step.',
      );
      _goTo(3);
      return;
    }

    setState(() => _busy = true);

    try {
      final nights = int.tryParse(_nights.text.trim()) ?? 0;
      final repo = ref.read(leadRepositoryProvider);

      final lead = await repo.createLead(
        LeadMapper.createBody(
          customerName: _customerName,
          phone: _phone.text,
          whatsapp: _whatsapp.text,
          email: _email.text,
          city: _customerCity.text,
          state: _customerState.text,
          country: _customerCountry.text,
          sourceWire: _source ?? 'Manual Entry',
          type: _type,
          stage: _stage,
          assignedUserId: assignee,
          birthDate: _birthDate,
          followUpDate: _followUpDate,
          travelDate: _travelDate,
          returnDate: _returnDate,
          budget: double.tryParse(_budget.text.trim().replaceAll(',', '')),
          departCity: _departCity.text,
          packageType: _packageType,
          departureModeWire: _travelMode.wire,
          rooms: _rooms,
          adults: _adults,
          male: _male,
          female: _female,
          children: _children,
          infants: _infants,
          extraBeds: _extraBeds,
          specialAssistanceRequired: _assistance,
          assistancePassengerCount: _assistance ? _assistancePax : null,
          specialAssistanceNotes: _assistance ? _assistanceNotes.text : null,
          notes: _notes.text,
          itinerary: _destination.text.trim().isEmpty || nights <= 0
              ? null
              : [
                  LeadItineraryStop(
                    destination: _destination.text.trim(),
                    city: _city.text.trim().isEmpty
                        ? _destination.text.trim()
                        : _city.text.trim(),
                    nights: nights,
                  ),
                ],
        ),
      );

      // Everything below is best-effort. The lead exists from here on, so a
      // failure must read as "the extra did not save", never as "nothing saved".
      await _saveFollowUp(lead);

      if (!mounted) return;
      ref.read(leadsControllerProvider.notifier).upsert(lead);
      ref.invalidate(leadStageCountsProvider);
      AppToast.success(context, 'Lead created', lead.customerName);
      context.backOrHome();
      // The quotation builder is one of the shell's unbacked screens; it names
      // the endpoint it is waiting on rather than pretending to be ready.
      if (thenQuotation) context.push(Routes.quotationCreate);
    } on Failure catch (f) {
      if (!mounted) return;
      // 409 means a lead already exists with this phone or email.
      AppToast.error(context, 'Could not create lead', f.message);
      if (f is ConflictFailure || f is ValidationFailure) _goTo(0);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  /// The note becomes activity history; the date, time and type become a task
  /// on the calendar. `createReminder` stays false so the follow-up is one row
  /// there, not a reminder and a task saying the same thing.
  Future<void> _saveFollowUp(Lead lead) async {
    final repo = ref.read(leadRepositoryProvider);
    final note = _followUpNote.text.trim();

    if (note.length >= 5) {
      try {
        await repo.addLog(lead.id, comment: note, createReminder: false);
      } on Failure catch (f) {
        if (mounted) {
          AppToast.error(context, 'Lead saved, note not logged', f.message);
        }
      }
    }

    final day = _followUpDate;
    if (day == null) return;

    try {
      await ref.read(taskApiProvider).createTask(
            title: '${_followUpType.label} — ${lead.customerName}',
            at: DateTime(
              day.year,
              day.month,
              day.day,
              _followUpTime.hour,
              _followUpTime.minute,
            ),
            allDay: false,
            category: _followUpType,
            priority: _followUpPriority,
            notes: note.isEmpty ? null : note,
            leadPublicId: lead.id,
          );
    } on Failure catch (f) {
      if (mounted) {
        AppToast.error(context, 'Lead saved, follow-up not scheduled', f.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leadingWidth: 56,
        leading: IconButton(
          onPressed: _back,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: _index == 0 ? 'Cancel' : 'Previous step',
        ),
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('New lead', style: AppType.h2),
            Text(
              'Step ${_index + 1} of ${_steps.length} · ${_steps[_index]}',
              style: AppType.caption.copyWith(fontSize: 11.5),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.gutter),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x10,
                vertical: AppSpacing.x4,
              ),
              decoration: BoxDecoration(
                color: AppColors.canvas,
                borderRadius: BorderRadius.circular(AppRadii.chip),
              ),
              child: Text(
                'Draft',
                style: AppType.monoSm.copyWith(color: AppColors.faint),
              ),
            ),
          ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      // One Form across all five pages: with nothing gating the steps, the
      // save-time validation has to see fields that live on other pages.
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _ProgressBar(
              steps: _steps,
              index: _index,
              // Any step, in any direction — nothing has to be filled first.
              onTap: _goTo,
            ),
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  _step(_customerStep()),
                  _step(_travellersStep()),
                  _step(_travelStep()),
                  _step(_leadInfoStep()),
                  _step(_followUpStep()),
                ],
              ),
            ),
            _Footer(
              busy: _busy,
              isLast: _index == _steps.length - 1,
              showBack: _index > 0,
              onBack: _back,
              onNext: _busy ? null : _next,
              onSaveAndQuote:
                  _busy ? null : () => _submit(thenQuotation: true),
              onCancel: _busy ? null : () => context.backOrHome(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step(Widget child) => ListView(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        children: [child, const SizedBox(height: AppSpacing.x24)],
      );

  Widget _customerStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Customer details',
            subtitle: 'Who is enquiring? Mobile number is used for WhatsApp sync.',
          ),
          _Pair(
            left: AppField(
              label: 'First name',
              controller: _firstName,
              hintText: 'Rahul',
              textInputAction: TextInputAction.next,
              // The server needs 2–150 characters of name in total; which of
              // the two boxes it comes from is up to whoever is typing.
              validator: (_) {
                final name = _customerName;
                if (name.isEmpty) return 'Enter the customer name';
                if (name.length < 2) return 'Name must be at least 2 characters';
                if (name.length > 150) return 'Name must be under 150 characters';
                return null;
              },
            ),
            right: AppField(
              label: 'Last name',
              controller: _lastName,
              hintText: 'Sharma',
              textInputAction: TextInputAction.next,
            ),
          ),
          _Pair(
            left: AppField(
              label: 'Mobile number',
              controller: _phone,
              hintText: '98220 41155',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) => Phone.isValid(v ?? '')
                  ? null
                  : 'Enter a valid 10-digit Indian mobile number',
            ),
            right: AppField(
              label: 'WhatsApp number',
              controller: _whatsapp,
              hintText: 'Same as mobile',
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
            ),
          ),
          AppField(
            label: 'Email',
            controller: _email,
            hintText: 'rahul.sharma@gmail.com',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) {
              final value = v?.trim() ?? '';
              if (value.isEmpty) return null;
              if (!value.contains('@') || !value.contains('.')) {
                return 'Enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.x12),
          _Pair(
            left: AppField(
              label: 'City',
              controller: _customerCity,
              hintText: 'Pune',
              textInputAction: TextInputAction.next,
            ),
            right: AppField(
              label: 'State',
              controller: _customerState,
              hintText: 'Maharashtra',
              textInputAction: TextInputAction.next,
            ),
          ),
          _Pair(
            left: AppField(
              label: 'Country',
              controller: _customerCountry,
              textInputAction: TextInputAction.next,
            ),
            right: _DateField(
              label: 'Date of birth',
              value: _birthDate,
              firstDate: DateTime(1920),
              lastDate: DateTime.now(),
              onChanged: (d) => setState(() => _birthDate = d),
            ),
          ),
        ],
      );

  Widget _travellersStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Traveller information',
            subtitle: 'Pax break-up drives hotel rooms and vehicle sizing.',
          ),
          _Pair(
            left: _Stepper(
              label: 'Adults',
              value: _adults,
              min: 1,
              onChanged: (v) => setState(() => _adults = v),
            ),
            right: _Stepper(
              label: 'Male',
              value: _male,
              onChanged: (v) => setState(() => _male = v),
            ),
          ),
          _Pair(
            left: _Stepper(
              label: 'Female',
              value: _female,
              onChanged: (v) => setState(() => _female = v),
            ),
            right: _Stepper(
              label: 'Children',
              value: _children,
              onChanged: (v) => setState(() => _children = v),
            ),
          ),
          _Pair(
            left: _Stepper(
              label: 'Infants',
              value: _infants,
              onChanged: (v) => setState(() => _infants = v),
            ),
            // `assistancePassengerCount` — how many of the party need help.
            right: _Stepper(
              label: 'Assistance',
              value: _assistancePax,
              onChanged: (v) => setState(() => _assistancePax = v),
            ),
          ),
          _Pair(
            left: _Stepper(
              label: 'Extra beds',
              value: _extraBeds,
              onChanged: (v) => setState(() => _extraBeds = v),
            ),
            right: _Stepper(
              label: 'Rooms',
              value: _rooms,
              onChanged: (v) => setState(() => _rooms = v),
            ),
          ),
          _Pair(
            left: _SwitchTile(
              label: 'Special assistance',
              value: _assistance,
              onChanged: (v) => setState(() => _assistance = v),
            ),
            right: AppField(
              label: 'Assistance details',
              controller: _assistanceNotes,
              hintText: 'Wheelchair at KTM airport',
              enabled: _assistance,
            ),
          ),
        ],
      );

  Widget _travelStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'Travel details',
            subtitle: 'Dates and destination. Nights auto-calculate from the range.',
          ),
          _Pair(
            left: AppField(
              label: 'Departure city',
              controller: _departCity,
              hintText: 'Pune',
              textInputAction: TextInputAction.next,
            ),
            right: AppField(
              label: 'Destination',
              controller: _destination,
              hintText: 'Nepal',
              textInputAction: TextInputAction.next,
            ),
          ),
          AppField(
            label: 'Destination city',
            controller: _city,
            hintText: 'Kathmandu & Pokhara',
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.x12),
          _Pair(
            left: _DateField(
              label: 'Start date',
              value: _travelDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
              onChanged: (d) => setState(() {
                _travelDate = d;
                _syncNights();
              }),
            ),
            right: _DateField(
              label: 'End date',
              value: _returnDate,
              firstDate: _travelDate ?? DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
              onChanged: (d) => setState(() {
                _returnDate = d;
                _syncNights();
              }),
            ),
          ),
          _Pair(
            left: AppField(
              label: 'Nights',
              controller: _nights,
              hintText: '6',
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
            ),
            // Derived, so it is shown rather than asked for.
            right: _ReadOnlyTile(
              label: 'Days',
              value: switch (int.tryParse(_nights.text.trim())) {
                final int n when n > 0 => '${n + 1}',
                _ => '—',
              },
            ),
          ),
          _Pair(
            left: _Picker<String>(
              label: 'Travel type',
              value: _packageType,
              values: _packageTypes,
              labelOf: (v) => v,
              onChanged: (v) => setState(() => _packageType = v),
            ),
            right: _Picker<_TravelMode>(
              label: 'Travel mode',
              value: _travelMode,
              values: _TravelMode.values,
              labelOf: (v) => v.label,
              onChanged: (v) => setState(() => _travelMode = v),
            ),
          ),
          AppField(
            label: 'Approx budget (₹)',
            controller: _budget,
            hintText: '1,85,000',
            keyboardType: TextInputType.number,
            validator: (v) {
              final raw = v?.trim() ?? '';
              if (raw.isEmpty) return null;
              final value = double.tryParse(raw.replaceAll(',', ''));
              if (value == null || value < 0) return 'Enter a valid amount';
              return null;
            },
          ),
        ],
      );

  Widget _leadInfoStep() {
    final sources = ref.watch(leadSourcesProvider);
    final assignment = ref.watch(assignmentChoiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _StepHeader(
          title: 'Lead information',
          subtitle: 'Scoring and assignment feed the pipeline and reports.',
        ),
        _Pair(
          // Sources come from the server catalog — it owns this vocabulary.
          left: switch (sources) {
            AsyncData(:final value) when value.isNotEmpty => _Picker<String>(
                label: 'Lead source',
                value: _source ?? value.first.value,
                values: value.map((o) => o.value).toList(growable: false),
                labelOf: (v) => v,
                onChanged: (v) => setState(() => _source = v),
              ),
            AsyncError() => _ReadOnlyTile(
                label: 'Lead source',
                value: _source ?? 'Manual Entry',
              ),
            _ => const _LoadingField(label: 'Lead source'),
          },
          right: _Picker<LeadStage>(
            label: 'Lead stage',
            value: _stage,
            values: LeadStage.values,
            labelOf: (v) => v.label,
            onChanged: (v) => setState(() => _stage = v),
          ),
        ),
        _Picker<LeadType>(
          label: 'Lead priority',
          value: _type,
          values: LeadType.values,
          labelOf: (v) => v.label,
          onChanged: (v) => setState(() => _type = v),
        ),
        const SizedBox(height: AppSpacing.x12),
        // Every lead needs an owner; when the tenant forces self-assignment
        // the server sends no list, so show the single owner read-only.
        switch (assignment) {
          AsyncData(:final value) => value.forcedSelf || value.eligibleUsers.isEmpty
              ? _ReadOnlyTile(
                  label: 'Assigned agent',
                  value: value.self?.name ?? 'You',
                )
              : _Picker<String>(
                  label: 'Assigned agent',
                  value: _assignedUserId ??
                      value.recommendedUserId ??
                      value.eligibleUsers.first.id,
                  values: value.eligibleUsers.map((u) => u.id).toList(growable: false),
                  labelOf: (id) {
                    final user = value.eligibleUsers.firstWhere((u) => u.id == id);
                    return user.activeLeads == null
                        ? user.name
                        : '${user.name} · ${user.activeLeads} active';
                  },
                  onChanged: (v) => setState(() => _assignedUserId = v),
                ),
          AsyncError() => const _Note(
              'Could not load the agent list. The lead will be assigned to you.',
            ),
          _ => const _LoadingField(label: 'Assigned agent'),
        },
        const SizedBox(height: AppSpacing.x12),
        AppField(
          label: 'Notes',
          controller: _notes,
          hintText: 'Prefers 4★ hotels, Buddha Air for Pokhara leg',
          maxLines: 3,
          validator: (v) => (v != null && v.length > 2000)
              ? 'Notes must be under 2000 characters'
              : null,
        ),
      ],
    );
  }

  Widget _followUpStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _StepHeader(
            title: 'First follow-up',
            subtitle: 'Scheduled on your calendar and shown on the lead.',
          ),
          _Pair(
            left: _DateField(
              label: 'Follow-up date',
              value: _followUpDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              onChanged: (d) => setState(() => _followUpDate = d),
            ),
            right: _TimeField(
              label: 'Follow-up time',
              value: _followUpTime,
              enabled: _followUpDate != null,
              onChanged: (t) => setState(() => _followUpTime = t),
            ),
          ),
          _Pair(
            left: _Picker<TaskCategory>(
              label: 'Follow-up type',
              value: _followUpType,
              values: TaskCategory.values,
              labelOf: (v) => v.label,
              onChanged: (v) => setState(() => _followUpType = v),
            ),
            // The spec pairs the type with a reminder offset, which the task
            // endpoint has no field for. Priority is the real setting that
            // belongs beside it and it rides on the same task.
            right: _Picker<TaskPriority>(
              label: 'Priority',
              value: _followUpPriority,
              values: TaskPriority.values,
              labelOf: (v) => v.label,
              onChanged: (v) => setState(() => _followUpPriority = v),
            ),
          ),
          AppField(
            label: 'Notes',
            controller: _followUpNote,
            hintText: 'Share revised Nepal quote',
            maxLines: 3,
            validator: (v) {
              final value = v?.trim() ?? '';
              // The log endpoint enforces 5–2000; empty just skips the log.
              if (value.isEmpty) return null;
              if (value.length < 5) return 'Write at least 5 characters, or leave it blank';
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.x12),
          const _Note(
            'Leave the date blank to save the lead without scheduling anything.',
          ),
        ],
      );
}

/// The step's own heading, as in the spec — the app bar carries "Step 3 of 5",
/// this says what the step is for.
class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppType.h2),
          const SizedBox(height: AppSpacing.x2),
          Text(subtitle, style: AppType.bodySm),
        ],
      ),
    );
  }
}

/// Two controls side by side, the spec's grid.
class _Pair extends StatelessWidget {
  const _Pair({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: AppSpacing.x10),
          Expanded(child: right),
        ],
      ),
    );
  }
}

/// A value the form shows but does not ask for.
class _ReadOnlyTile extends StatelessWidget {
  const _ReadOnlyTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x14,
        AppSpacing.x12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppType.overline),
          const SizedBox(height: AppSpacing.x4),
          Text(
            value,
            style: AppType.fieldValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x8,
        AppSpacing.x10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppType.overline),
          Row(
            children: [
              Expanded(
                child: Text(
                  value ? 'Required' : 'Not required',
                  style: AppType.fieldValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Switch.adaptive(value: value, onChanged: onChanged),
            ],
          ),
        ],
      ),
    );
  }
}

/// Placeholder while a picker's options are still loading.
class _LoadingField extends StatelessWidget {
  const _LoadingField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppType.overline),
        const SizedBox(height: AppSpacing.x8),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.canvas,
            borderRadius: BorderRadius.circular(AppRadii.tile),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          alignment: Alignment.centerLeft,
          child: const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.steps, required this.index, required this.onTap});

  final List<String> steps;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.gutter,
        AppSpacing.x12,
        AppSpacing.gutter,
        AppSpacing.x14,
      ),
      child: Row(
        children: [
          for (var i = 0; i < steps.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.x6),
            Expanded(
              child: Semantics(
                button: true,
                selected: i == index,
                label: 'Step ${i + 1}: ${steps[i]}',
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i <= index ? AppColors.primary : AppColors.line,
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x8),
                      Text(
                        steps[i],
                        style: AppType.caption.copyWith(
                          fontSize: 11,
                          color: i <= index ? AppColors.primary : AppColors.faint,
                          fontWeight: i == index ? FontWeight.w700 : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.busy,
    required this.isLast,
    required this.showBack,
    required this.onBack,
    required this.onNext,
    required this.onSaveAndQuote,
    required this.onCancel,
  });

  final bool busy;
  final bool isLast;
  final bool showBack;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final VoidCallback? onSaveAndQuote;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.gutter,
            AppSpacing.x12,
            AppSpacing.gutter,
            AppSpacing.x4,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (showBack) ...[
                    // Explicit width: the themed `minimumSize` is
                    // `Size.fromHeight`, which constrains the height and
                    // leaves the width to shrink-wrap inside the Row.
                    SizedBox(
                      width: 104,
                      child: OutlinedButton(
                        onPressed: busy ? null : onBack,
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x10),
                  ],
                  Expanded(
                    child: FilledButton(
                      onPressed: onNext,
                      child: busy
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.onPrimary,
                              ),
                            )
                          : Text(isLast ? 'Save lead' : 'Continue'),
                    ),
                  ),
                ],
              ),
              if (isLast) ...[
                const SizedBox(height: AppSpacing.x10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onSaveAndQuote,
                    style: FilledButton.styleFrom(backgroundColor: AppColors.ink),
                    child: const Text('Save & create quotation'),
                  ),
                ),
              ],
              TextButton(
                onPressed: onCancel,
                child: Text(
                  'Cancel',
                  style: AppType.bodySm.copyWith(color: AppColors.faint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Stepper extends StatelessWidget {
  const _Stepper({
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 0,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;

  /// Upper bound. Traveller counts have no server-side maximum; this is a
  /// sanity limit so a mis-tap cannot run away.
  static const max = 99;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x12,
        AppSpacing.x8,
        AppSpacing.x4,
        AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label.toUpperCase(),
            style: AppType.overline,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            children: [
              _Round(
                // A minus bar, drawn rather than picked from the icon set —
                // the closest glyph there is a cross, which reads as "remove".
                label: 'Decrease $label',
                enabled: value > min,
                onTap: () => onChanged(value - 1),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: AppType.monoStrong,
                ),
              ),
              _Round(
                icon: Ic.plus,
                label: 'Increase $label',
                enabled: value < max,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Round extends StatelessWidget {
  const _Round({
    required this.label,
    required this.enabled,
    required this.onTap,
    this.icon,
  });

  /// Omit for a minus bar — the icon set has no minus, only a cross.
  final String? icon;
  final String label;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(AppRadii.pill),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: enabled ? AppColors.primaryTint : AppColors.canvas,
                shape: BoxShape.circle,
              ),
              child: icon == null
                  ? Container(
                      width: 11,
                      height: 2,
                      decoration: BoxDecoration(
                        color: enabled ? AppColors.primary : AppColors.faint,
                        borderRadius: BorderRadius.circular(1),
                      ),
                    )
                  : AppIcon(
                      icon!,
                      size: 13,
                      color: enabled ? AppColors.primary : AppColors.faint,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x12,
        AppSpacing.x12,
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate:
              value ?? (firstDate.isAfter(DateTime.now()) ? firstDate : DateTime.now()),
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (picked != null) onChanged(picked);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppType.overline),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value == null ? 'Select' : AppDate.display(value),
                  style: AppType.fieldValue.copyWith(
                    color: value == null ? AppColors.faint : AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const AppIcon(Ic.calendar, size: 16, color: AppColors.faint),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final TimeOfDay value;
  final bool enabled;
  final ValueChanged<TimeOfDay> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x12,
        AppSpacing.x12,
      ),
      onTap: enabled
          ? () async {
              final picked = await showTimePicker(context: context, initialTime: value);
              if (picked != null) onChanged(picked);
            }
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppType.overline),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  value.format(context),
                  style: AppType.fieldValue.copyWith(
                    color: enabled ? AppColors.ink : AppColors.faint,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const AppIcon(Ic.clock, size: 16, color: AppColors.faint),
            ],
          ),
        ],
      ),
    );
  }
}

class _Picker<T> extends StatelessWidget {
  const _Picker({
    required this.label,
    required this.value,
    required this.values,
    required this.labelOf,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<T> values;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x14,
        AppSpacing.x10,
        AppSpacing.x12,
        AppSpacing.x12,
      ),
      onTap: () async {
        final picked = await showModalBottomSheet<T>(
          context: context,
          backgroundColor: AppColors.surface,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.rSheet),
          builder: (context) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.x16),
                  child: Text(label, style: AppType.h2),
                ),
                for (final v in values)
                  ListTile(
                    onTap: () => Navigator.of(context).pop(v),
                    title: Text(labelOf(v), style: AppType.fieldValue),
                    trailing: v == value
                        ? const AppIcon(Ic.check, size: 18, color: AppColors.primary)
                        : null,
                  ),
              ],
            ),
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label.toUpperCase(), style: AppType.overline),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  labelOf(value),
                  style: AppType.fieldValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const AppIcon(Ic.chevronDown, size: 16, color: AppColors.faint),
            ],
          ),
        ],
      ),
    );
  }
}

class _Note extends StatelessWidget {
  const _Note(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppIcon(Ic.alert, size: 15, color: AppColors.faint),
        const SizedBox(width: AppSpacing.x8),
        Expanded(
          child: Text(text, style: AppType.caption.copyWith(fontSize: 11.5)),
        ),
      ],
    );
  }
}
