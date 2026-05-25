// ============================================================
// HomeScreen — XPM Mobile
// Prototype : home.html
// Design spec: DESIGN.md §11.1
// ============================================================
// Widget tree:
//   MpBasicLayout
//   ├─ appBar  : MpBaseAppBar (transparent)
//   │            title → Column(greeting Text + name Text)
//   │            actions → [Stack(MpIconButton(inbox) + MpBadge.negative)]
//   │            leading → MpAvatar.image + MpAvatarVariationIcon (right-side)
//   ├─ stage:
//   │   ├─ _SummaryCard         Custom Container (bg-stage, MpRadius.xLarge)
//   │   ├─ _AttentionSection    Custom Container (MpIconAvatar tiles)
//   │   ├─ _BudgetWidget        MpHeaderListTileX.double + 2×2 BudgetCategoryCard grid
//   │   └─ _RecentTransactions  MpHeaderListTileX.double + MpSingleFilter + MpListTileX list
//   ├─ bottomNavigationBar: MpBottomNavBar (currentIndex: 0)
//   └─ floatingActionButton: MpFloatingActionButton (label: 'Request')
//
// Tokens: see DESIGN.md §5
// Custom colors: XpmColors.bgBase (page bg), XpmColors.budgetCardBg, XpmColors.budgetTrackBg
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';
import '../../sheets/fab_menu_sheet.dart';
import '../../widgets/budget_card/budget_category_card.dart';
import '../../widgets/summary_card/summary_card.dart';
import '../inbox/inbox_screen.dart';
import '../my_requests/my_requests_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routeName = '/home';

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      extendStageBottom: true,
      extendStageTop: true,
      appBar: MpBaseAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const _GreetingTitle(),
        actions: [
          // Inbox icon with unread badge
          // TODO: replace hardcoded badge count with real unread count
          Stack(
            clipBehavior: Clip.none,
            children: [
              MpIconButton(
                icon: MpIcons.alert.bell,
                onPressed: () => context.push(InboxScreen.routeName),
              ),
              Positioned(
                top: -4,
                right: -4,
                child: MpBadge.negative(
                  text: '3',
                  size: MpBadgeSize.small,
                ),
              ),
            ],
          ),
          // User avatar with online indicator
          // TODO: replace with real user photo URL
          MpAvatar.image(path: 'https://placeholder.com/avatar.jpg'),
        ],
      ),
      stage: [
        MpContent(child: _SummaryCard()),
        MpContent(child: _AttentionSection()),
        MpContent(child: _BudgetWidget()),
        MpContent(child: _RecentTransactions()),
      ],
      bottomNavigationBar: MpBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          // TODO: navigate to tab screens based on index
          // 0 = Home, 1 = My requests, 2 = Purchases, 3 = My cards
          if (index == 1) context.go(MyRequestsScreen.routeName);
        },
        items: const [
          MpBottomNavBarItemData(
            label: 'Home',
            icon: MpIcons.feature.home,
          ),
          MpBottomNavBarItemData(
            label: 'My requests',
            icon: MpIcons.feature.document,
          ),
          MpBottomNavBarItemData(
            label: 'Purchases',
            icon: MpIcons.feature.purchase,
          ),
          MpBottomNavBarItemData(
            label: 'My cards',
            icon: MpIcons.feature.card,
          ),
        ],
      ),
      floatingActionButton: MpFloatingActionButton(
        label: 'Request',
        icon: MpIcons.interfaceEssential.add.toIcon(
          color: MpColors.text.inverse,
        ),
        onPressed: () => FabMenuSheet.show(context),
      ),
    );
  }
}

// ── Private sub-widgets ──────────────────────────────────────

class _GreetingTitle extends StatelessWidget {
  const _GreetingTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good morning,',
          // DESIGN.md §2: MpTextStyles.sm, text-secondary
          style: MpTextStyles.sm.copyWith(
            color: MpColors.text.secondary.resolve(context),
          ),
        ),
        Text(
          'Rizal Chandra', // TODO: replace with real user name
          // DESIGN.md §2: MpTextStyles.l semiBold, text-primary
          style: MpTextStyles.l.semiBold.copyWith(
            color: MpColors.text.primary.resolve(context),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.1: Custom Container — no Pixel equivalent
    // bg-stage, borderRadius: MpRadius.xLarge, padding: MpSpacing.medium
    return SummaryCard(
      // TODO: wire up with real data
      totalAmount: 'Rp1.511.000',
      pendingCount: 3,
      awaitingAmount: 'Rp150.000',
      disbursedAmount: 'Rp1.300.000',
    );
  }
}

class _AttentionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.1: Custom Container with MpIconAvatar tiles
    // Tile → InkWell + Column(MpIconAvatar, count, label)
    // TODO: implement attention tiles for Claims, Trips, Purchases
    return const SizedBox.shrink();
  }
}

class _BudgetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.1:
    // Header: MpHeaderListTileX.double(label: 'Categories limit', caption: 'View all')
    // Body: 2×2 GridView of BudgetCategoryCard
    // bg-stage container, borderRadius: MpRadius.medium
    return Column(
      children: [
        MpHeaderListTileX.double(
          label: 'Categories limit',
          caption: 'View all',
          trailing: Icon(
            Icons.chevron_right,
            color: MpColors.text.link.resolve(context),
          ),
        ),
        // TODO: 2×2 grid — replace with real budget category data
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            BudgetCategoryCard(
              title: 'Transport claim',
              availableAmount: 'Rp11.250.000',
              limitAmount: 'Rp15.000.000/month',
              spentRatio: 0.25,
            ),
            BudgetCategoryCard(
              title: 'Meals & Entertainment',
              availableAmount: 'Rp5.000.000',
              limitAmount: 'Rp8.000.000/month',
              spentRatio: 0.63,
            ),
            BudgetCategoryCard(
              title: 'Accommodation',
              availableAmount: 'Rp600.000',
              limitAmount: 'Rp5.000.000/month',
              spentRatio: 0.88,
            ),
            BudgetCategoryCard(
              title: 'Subscription',
              availableAmount: '',
              limitAmount: '',
              spentRatio: 0,
              hasNoLimit: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _RecentTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.1:
    // Header: MpHeaderListTileX.double(label: 'Recent transactions', caption: 'View all')
    // Filter: MpSingleFilter (All / Disbursed / Awaiting approval)
    // Date header: MpHeaderListTileX.single(label: 'May 2026')
    // Items: MpListTileX (leading: MpIconAvatar, content: double-line, trailing: amount + badge)
    // TODO: implement with real transaction data
    return const SizedBox.shrink();
  }
}
