import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import 'screens/home/home_screen.dart';
import 'screens/my_requests/my_requests_screen.dart';
import 'screens/inbox/inbox_screen.dart';
import 'screens/reimb/reimb_screen.dart';
import 'screens/reimb_form/reimb_form_screen.dart';
import 'screens/classify/classify_screen.dart';
import 'screens/receipt_preview/receipt_preview_screen.dart';
import 'screens/trip_form/trip_form_screen.dart';
import 'screens/trip_detail/trip_detail_screen.dart';
import 'screens/create_report/create_report_screen.dart';

// ============================================================
// XPM — Mekari Expense Mobile App
// Proto: index.html → home.html (entry point)
// Design spec: DESIGN.md
// ============================================================

void main() {
  runApp(const XpmApp());
}

final _router = GoRouter(
  initialLocation: HomeScreen.routeName,
  routes: [
    GoRoute(
      path: HomeScreen.routeName,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: MyRequestsScreen.routeName,
      builder: (context, state) => const MyRequestsScreen(),
    ),
    GoRoute(
      path: InboxScreen.routeName,
      builder: (context, state) => const InboxScreen(),
    ),
    GoRoute(
      path: ReimbScreen.routeName,
      builder: (context, state) => const ReimbScreen(),
    ),
    GoRoute(
      path: ReimbFormScreen.routeName,
      builder: (context, state) => const ReimbFormScreen(),
    ),
    GoRoute(
      path: ClassifyScreen.routeName,
      builder: (context, state) => const ClassifyScreen(),
    ),
    GoRoute(
      path: ReceiptPreviewScreen.routeName,
      builder: (context, state) => const ReceiptPreviewScreen(),
    ),
    GoRoute(
      path: TripFormScreen.routeName,
      builder: (context, state) => const TripFormScreen(),
    ),
    GoRoute(
      path: TripDetailScreen.routeName,
      builder: (context, state) => const TripDetailScreen(),
    ),
    GoRoute(
      path: CreateReportScreen.routeName,
      builder: (context, state) => const CreateReportScreen(),
    ),
  ],
);

class XpmApp extends StatelessWidget {
  const XpmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MpApp(
      // TODO: configure MpApp with correct theme, locale, etc.
      title: 'XPM',
      router: _router,
    );
  }
}
