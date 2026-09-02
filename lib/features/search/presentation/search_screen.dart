import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/status_colors.dart';
import '../../../core/di.dart';
import '../../../core/errors/failure.dart';
import '../../../core/icons/app_icon.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/search_api.dart';
import '../../../router/routes.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/state_views.dart';
import '../../../widgets/status_chip.dart';
import '../../../router/safe_pop.dart';

/// Global search — `GET /api/search`, across leads, customers, bookings,
/// quotations, vendors and invoices.
///
/// The server returns only the record types the caller has read permission
/// for, so the scope chips filter the results that came back rather than
/// asking for types the user cannot see. Only leads are navigable today; the
/// other types open once their screens are wired.
class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  Timer? _debounce;
  List<SearchHit> _results = const [];
  String? _scope;
  bool _searching = false;
  bool _hasSearched = false;
  Failure? _failure;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    // The server treats a query under two characters as empty anyway.
    if (query.length < 2) {
      setState(() {
        _hasSearched = false;
        _results = const [];
        _failure = null;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () => _search(query));
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 2) return;

    setState(() {
      _searching = true;
      _failure = null;
    });

    try {
      final hits = await ref.read(searchApiProvider).search(query);
      if (!mounted) return;
      setState(() {
        _results = hits;
        _hasSearched = true;
      });
    } on Failure catch (f) {
      if (mounted) setState(() => _failure = f);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _open(SearchHit hit) {
    if (hit.type == 'LEAD') {
      context.push(Routes.leadDetailFor(hit.publicId));
      return;
    }
    // Other record types have no screen yet; say so instead of doing nothing.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${hit.typeLabel} screens are not wired up yet.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scopes = <String>{for (final hit in _results) hit.type}.toList()..sort();
    final visible =
        _scope == null ? _results : _results.where((h) => h.type == _scope).toList();

    return Scaffold(
      backgroundColor: AppColors.canvas,
      appBar: AppBar(
        leading: IconButton(
          onPressed: context.backOrHome,
          icon: const AppIcon(Ic.back, size: 20, color: AppColors.ink),
          tooltip: 'Back',
        ),
        titleSpacing: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          onChanged: _onChanged,
          onSubmitted: (v) => _search(v.trim()),
          style: AppType.fieldValue,
          cursorColor: AppColors.primary,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search leads, customers, bookings…',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
          ),
        ),
        actions: [
          if (_searching)
            const Padding(
              padding: EdgeInsets.only(right: AppSpacing.x16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else if (_controller.text.isNotEmpty)
            IconButton(
              onPressed: () {
                _controller.clear();
                _onChanged('');
              },
              icon: const AppIcon(Ic.close, size: 18, color: AppColors.muted),
              tooltip: 'Clear',
            ),
        ],
        shape: const Border(bottom: BorderSide(color: AppColors.line)),
      ),
      body: Column(
        children: [
          if (scopes.length > 1)
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.gutter,
                  vertical: AppSpacing.x10,
                ),
                children: [
                  _ScopeChip(
                    label: 'All',
                    count: _results.length,
                    active: _scope == null,
                    onTap: () => setState(() => _scope = null),
                  ),
                  for (final scope in scopes) ...[
                    const SizedBox(width: AppSpacing.x8),
                    _ScopeChip(
                      label: _results.firstWhere((h) => h.type == scope).typeLabel,
                      count: _results.where((h) => h.type == scope).length,
                      active: _scope == scope,
                      onTap: () => setState(() => _scope = _scope == scope ? null : scope),
                    ),
                  ],
                ],
              ),
            ),
          Expanded(child: _body(visible)),
        ],
      ),
    );
  }

  Widget _body(List<SearchHit> visible) {
    if (_failure != null) {
      return ErrorStateView(
        failure: _failure!,
        onRetry: () => _search(_controller.text.trim()),
      );
    }

    if (!_hasSearched) {
      return const EmptyStateView(
        icon: Ic.search,
        title: 'Search your workspace',
        message: 'Find a lead, customer, booking, quotation, vendor or invoice '
            'by name, code, phone or email.',
      );
    }

    if (visible.isEmpty) {
      return EmptyStateView(
        icon: Ic.search,
        title: 'No results',
        message: 'Nothing matches "${_controller.text.trim()}".',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.gutter),
      itemCount: visible.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.x10),
      itemBuilder: (context, index) => _HitCard(
        hit: visible[index],
        onTap: () => _open(visible[index]),
      ),
    );
  }
}

class _HitCard extends StatelessWidget {
  const _HitCard({required this.hit, required this.onTap});

  final SearchHit hit;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.x14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hit.title.isEmpty ? '—' : hit.title,
                  style: AppType.h3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hit.subtitle != null) ...[
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    hit.subtitle!,
                    style: AppType.bodySm,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: AppSpacing.x8),
                Wrap(
                  spacing: AppSpacing.x8,
                  children: [
                    StatusChip(label: hit.typeLabel, palette: StatusColors.neutral, dense: true),
                    if (hit.status != null)
                      StatusChip(
                        label: hit.status!,
                        palette: StatusColors.neutral,
                        dense: true,
                      ),
                  ],
                ),
              ],
            ),
          ),
          const AppIcon(Ic.chevronRight, size: 16, color: AppColors.faint),
        ],
      ),
    );
  }
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({
    required this.label,
    required this.count,
    required this.active,
    required this.onTap,
  });

  final String label;
  final int count;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.chip),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadii.chip),
            border: Border.all(color: active ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: AppType.tab.copyWith(
                  color: active ? AppColors.onPrimary : AppColors.body,
                ),
              ),
              const SizedBox(width: AppSpacing.x6),
              Text(
                '$count',
                style: AppType.monoSm.copyWith(
                  color: active
                      ? AppColors.onPrimary.withValues(alpha: 0.8)
                      : AppColors.faint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
