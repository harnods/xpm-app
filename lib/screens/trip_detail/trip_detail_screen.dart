// ============================================================
// TripDetailScreen — XPM Mobile
// Prototype : trip-detail.html
// Design spec: DESIGN.md §11.9
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar(title: tripName, leading: back)
//   └─ stage:
//       ├─ MpBadge.*Status        trip status pill
//       ├─ MpListTileX            trip summary (dates + budget)
//       ├─ _ExpenseList           MpListTileX per expense
//       ├─ MpButton.secondary     + Add expense → TripFormScreen
//       └─ MpButton.primary       Create report → CreateReportScreen
//
// Status badge mapping (DESIGN.md §11.9):
//   'Awaiting report'   → MpBadge.neutralStatus
//   'Awaiting approval' → MpBadge.noticeStatus
//   'Approved'          → MpBadge.positiveStatus
//   'Rejected'          → MpBadge.negativeStatus
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';
import '../create_report/create_report_screen.dart';
import '../trip_form/trip_form_screen.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  static const routeName = '/trip-detail';

  @override
  Widget build(BuildContext context) {
    // TODO: receive trip data via GoRouter extra or state management
    const tripName = 'Business trip · Surabaya';
    const tripStatus = 'Awaiting report';

    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: tripName,
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      stage: [
        // Status badge
        MpContent(
          child: Padding(
            padding: const EdgeInsets.all(MpSpacing.medium),
            child: _statusBadge(tripStatus),
          ),
        ),

        // Trip summary tile
        // DESIGN.md §11.9: MpListTileX(leading: MpIconAvatar, content: dates + budget)
        MpContent(
          child: MpListTileX(
            leading: MpIconAvatar(
              icon: MpIcons.feature.airplane,
              backgroundColor: MpColors.bg.highlight,
            ),
            content: MpListTileXContent.double(
              label: '12 Jun – 16 Jun 2023',
              caption: 'Budget: Rp1.200.000 · 4 expenses',
            ),
          ),
        ),

        // Expense list
        MpContent(child: _ExpenseList()),

        // Add expense
        MpContent(
          child: MpButton.secondary(
            label: '+ Add expense',
            onPressed: () => context.push(TripFormScreen.routeName),
          ),
        ),

        // Create report CTA
        MpContent(
          child: MpButton.primary(
            label: 'Create report',
            onPressed: () => context.push(CreateReportScreen.routeName),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    switch (status) {
      case 'Awaiting report':
        return MpBadge.neutralStatus(text: status);
      case 'Awaiting approval':
        return MpBadge.noticeStatus(text: status);
      case 'Approved':
        return MpBadge.positiveStatus(text: status);
      case 'Rejected':
        return MpBadge.negativeStatus(text: status);
      default:
        return MpBadge.neutralStatus(text: status);
    }
  }
}

class _ExpenseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.9: MpListTileX per expense
    // Same structure as My Requests claim item (§11.2)
    // TODO: implement with real expense data from trip
    return const SizedBox.shrink();
  }
}
