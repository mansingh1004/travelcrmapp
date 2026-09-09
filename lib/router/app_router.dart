import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/errors/failure.dart';
import '../core/icons/app_icon.dart';
import '../features/auth/auth.dart';
import '../features/bookings/bookings.dart';
import '../features/calendar/calendar.dart';
import '../features/customers/customers.dart';
import '../features/dashboard/dashboard.dart';
import '../features/inbox/inbox.dart';
import '../features/leads/leads.dart';
import '../features/operations/operations.dart';
import '../features/masters/masters.dart';
import '../features/reminders/reminders.dart';
import '../features/vendors/vendors.dart';
import '../features/notifications/notifications.dart';
import '../features/payments/payments.dart';
import '../features/profile/profile.dart';
import '../features/quotations/quotations.dart';
import '../features/reports/reports.dart';
import '../features/search/search.dart';
import '../features/settings/settings.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_screen.dart';
import 'routes.dart';

/// Notifies go_router when auth state changes, so guards re-evaluate.
class _AuthListenable extends ChangeNotifier {
  _AuthListenable(this._ref) {
    _ref.listen<AuthState>(
      authControllerProvider,
      (_, _) => notifyListeners(),
    );
  }

  final Ref _ref;
}

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = _AuthListenable(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final location = state.matchedLocation;

      const authRoutes = {Routes.login};
      final onAuthRoute = authRoutes.contains(location);

      return switch (auth) {
        // Still restoring the stored token — hold on the splash so the app
        // never flashes Login before auto-login resolves.
        AuthUnknown() => location == Routes.splash ? null : Routes.splash,
        AuthSignedOut() => onAuthRoute ? null : Routes.login,
        AuthSignedIn() =>
          (onAuthRoute || location == Routes.splash) ? Routes.dashboard : null,
      };
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),

      // ── Tabs, inside the persistent shell ────────────────────────────
      ShellRoute(
        navigatorKey: _shellKey,
        builder: (context, state, child) => AppShell(state: state, child: child),
        routes: [
          GoRoute(path: Routes.dashboard, builder: (_, _) => const DashboardScreen()),
          GoRoute(path: Routes.leads, builder: (_, _) => const LeadsScreen()),
          GoRoute(path: Routes.calendar, builder: (_, _) => const CalendarScreen()),
          GoRoute(path: Routes.bookings, builder: (_, _) => const BookingsScreen()),
          GoRoute(path: Routes.inbox, builder: (_, _) => const InboxScreen()),
        ],
      ),

      // ── Full-screen routes ───────────────────────────────────────────
      GoRoute(
        path: Routes.leadCreate,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const LeadCreateScreen(),
      ),
      GoRoute(
        path: Routes.leadDetail,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LeadDetailScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.leadEdit,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => LeadEditScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.customers,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const CustomersScreen(),
      ),
      // Before `/bookings/:id`, or "convert" would be read as a booking id.
      GoRoute(
        path: Routes.bookingConvert,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => BookingConvertScreen(
          leadId: state.uri.queryParameters['leadId'] ?? '',
          quotationId: state.uri.queryParameters['quotationId'],
        ),
      ),
      GoRoute(
        path: Routes.bookingDetail,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => BookingDetailScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.quotations,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const QuotationsScreen(),
      ),
      // `/quotations/new?leadId=…`, matching the console's `/createquotation`.
      // A quotation only exists against a lead — the server snapshots the
      // customer from it — so without the parameter there is nothing to build.
      GoRoute(
        path: Routes.quotationCreate,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => QuotationCreateScreen(
          leadId: state.uri.queryParameters['leadId'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.operations,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const OperationsScreen(),
      ),
      GoRoute(
        path: Routes.payments,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const PaymentsScreen(),
      ),
      GoRoute(
        path: Routes.reports,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ReportsScreen(),
      ),
      GoRoute(
        path: Routes.notifications,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const NotificationsScreen(),
      ),
      GoRoute(
        path: Routes.masters,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const MastersScreen(),
      ),
      GoRoute(
        path: Routes.vendors,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const VendorsScreen(),
      ),
      GoRoute(
        path: Routes.reminders,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const RemindersScreen(),
      ),
      GoRoute(
        path: Routes.settings,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const SettingsScreen(),
      ),
      GoRoute(
        path: Routes.chat,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => ChatScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.operationsDetail,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => OperationsDetailScreen(
          bookingId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.quotationPreview,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => QuotationPreviewScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.quotationEdit,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => QuotationEditScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.customerDetail,
        parentNavigatorKey: _rootKey,
        builder: (_, state) => CustomerDetailScreen(
          publicId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: Routes.search,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const SearchScreen(),
      ),
      GoRoute(
        path: Routes.profile,
        parentNavigatorKey: _rootKey,
        builder: (_, _) => const ProfileScreen(),
      ),

      // ── Screens with no backend ──────────────────────────────────────
      ..._placeholders,
    ],
    errorBuilder: (context, state) => PlaceholderScreen(
      title: 'Not found',
      icon: Ic.alert,
      failure: NotImplementedFailure(
        endpoint: state.uri.toString(),
        message: 'That screen does not exist.',
      ),
    ),
  );
});

/// The 18 screens the backend cannot support yet. Each is a real route with
/// real chrome — only the content is the "waiting on backend" panel.
final _placeholders = <GoRoute>[
  _placeholder(Routes.itinerary, 'Itinerary', Ic.pin, 'GET /api/itineraries',
      'The lead itinerary is only destination, city and nights — there is no day plan.'),
];

GoRoute _placeholder(
  String path,
  String title,
  String icon,
  String endpoint,
  String why,
) =>
    GoRoute(
      path: path,
      parentNavigatorKey: _rootKey,
      builder: (_, _) => PlaceholderScreen(
        title: title,
        icon: icon,
        failure: NotImplementedFailure(endpoint: endpoint, message: why),
      ),
    );
