// ============================================================
// MyRequestsScreen — XPM Mobile
// Prototype : my-requests.html
// Design spec: DESIGN.md §11.2
// ============================================================
// Widget tree:
//   MpBasicLayout
//   ├─ appBar  : MpTextAppBar(title: 'My requests', transparent)
//   ├─ stage:
//   │   ├─ MpSearch (onFilterPressed → FilterSheet)
//   │   ├─ _SummaryCard         Custom Container (same as Home)
//   │   ├─ _AiCreditsRow        Custom Container (bg-brand) — no Pixel equivalent
//   │   ├─ MpSingleFilter       (All / Claims / Trips)
//   │   ├─ MpFilter             active filter chips
//   │   └─ _RequestList         MpHeaderListTileX.single + MpListTileX per item
//   ├─ bottomNavigationBar: MpBottomNavBar (currentIndex: 1)
//   └─ floatingActionButton: MpFloatingActionButton (label: 'Request')
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';
import '../../sheets/fab_menu_sheet.dart';
import '../../sheets/filter_sheet.dart';
import '../../widgets/ai_credits_row/ai_credits_row.dart';
import '../../widgets/summary_card/summary_card.dart';
import '../home/home_screen.dart';

class MyRequestsScreen extends StatefulWidget {
  const MyRequestsScreen({super.key});

  static const routeName = '/my-requests';

  @override
  State<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends State<MyRequestsScreen> {
  int _selectedTabIndex = 0;
  final List<MpSingleFilterTagData> _tabs = const [
    MpSingleFilterTagData(label: 'All'),
    MpSingleFilterTagData(label: 'Claims'),
    MpSingleFilterTagData(label: 'Trips'),
  ];

  // TODO: replace with real active filter state
  final List<MpFilterTagData> _activeFilters = const [
    MpFilterTagData(label: 'May 2026'),
  ];

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      extendStageBottom: true,
      appBar: MpTextAppBar(
        title: 'My requests',
        backgroundColor: Colors.transparent,
      ),
      stage: [
        MpContent(
          child: MpSearch(
            hintText: 'Search vendor, type, or amount',
            onFilterPressed: () => FilterSheet.show(context),
          ),
        ),
        MpContent(
          child: SummaryCard(
            // TODO: wire up with real data
            totalAmount: 'Rp1.511.000',
            pendingCount: 3,
            awaitingAmount: 'Rp150.000',
            disbursedAmount: 'Rp1.300.000',
          ),
        ),
        MpContent(
          // DESIGN.md §11.2: Custom — no Pixel equivalent. See §10.12
          child: AiCreditsRow(creditsRemaining: 12),
        ),
        MpContent(
          child: MpSingleFilter(
            tags: _tabs,
            selectedIndex: _selectedTabIndex,
            onTapTag: (index) => setState(() => _selectedTabIndex = index),
          ),
        ),
        MpContent(
          child: MpFilter(
            tags: _activeFilters,
            onTapFilter: () => FilterSheet.show(context),
            onTapTag: (index) {
              // TODO: remove filter at index
            },
          ),
        ),
        MpContent(child: _RequestList(tabIndex: _selectedTabIndex)),
      ],
      bottomNavigationBar: MpBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) context.go(HomeScreen.routeName);
          // TODO: handle other tabs
        },
        items: const [
          MpBottomNavBarItemData(label: 'Home', icon: MpIcons.feature.home),
          MpBottomNavBarItemData(label: 'My requests', icon: MpIcons.feature.document),
          MpBottomNavBarItemData(label: 'Purchases', icon: MpIcons.feature.purchase),
          MpBottomNavBarItemData(label: 'My cards', icon: MpIcons.feature.card),
        ],
      ),
      floatingActionButton: MpFloatingActionButton(
        label: 'Request',
        icon: MpIcons.interfaceEssential.add.toIcon(color: MpColors.text.inverse),
        onPressed: () => FabMenuSheet.show(context),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  final int tabIndex;
  const _RequestList({required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.2:
    // Date header  → MpHeaderListTileX.single(label: '13 JUL')
    // Claim item   → MpListTileX(leading: MpIconAvatar, content: triple-line, trailing: amount)
    // Trip item    → MpListTileX.overline(label: tripName, caption: dateRange, trailing: ...)
    // Status badge → MpBadge.positiveStatus / .noticeStatus / .negativeStatus / .neutralStatus
    // TODO: implement list with real request data filtered by tabIndex
    return const SizedBox.shrink();
  }
}
