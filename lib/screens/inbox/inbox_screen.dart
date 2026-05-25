// ============================================================
// InboxScreen — XPM Mobile
// Prototype : inbox.html
// Design spec: DESIGN.md §11.3
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar
//   │          title → 'Inbox'
//   │          leading → back MpIconButton
//   │          actions → [MpButton.ghost('Mark all as read')]
//   └─ stage:
//       ├─ MpSingleFilter (Notifications / Need my approval)
//       └─ _NotificationList
//           ├─ unread → Container(left-border) + MpListTileX (bg-subtle)
//           └─ read   → MpListTileX (bg-stage)
//           └─ swipe  → Dismissible (Flutter built-in, no Pixel equivalent)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  static const routeName = '/inbox';

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  int _selectedTab = 0;

  final List<MpSingleFilterTagData> _tabs = [
    MpSingleFilterTagData(
      label: 'Notifications',
      icon: MpBadge.negative(text: '3', size: MpBadgeSize.small),
    ),
    MpSingleFilterTagData(
      label: 'Need my approval',
      icon: MpBadge.negative(text: '2', size: MpBadgeSize.small),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: 'Inbox',
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          MpButton.ghost(
            label: 'Mark all as read',
            onPressed: () {
              // TODO: mark all notifications as read
            },
          ),
        ],
      ),
      stage: [
        MpContent(
          child: MpSingleFilter(
            tags: _tabs,
            selectedIndex: _selectedTab,
            onTapTag: (index) => setState(() => _selectedTab = index),
          ),
        ),
        MpContent(child: _NotificationList(tab: _selectedTab)),
      ],
    );
  }
}

class _NotificationList extends StatelessWidget {
  final int tab;
  const _NotificationList({required this.tab});

  @override
  Widget build(BuildContext context) {
    // DESIGN.md §11.3 — notification items:
    //
    // UNREAD item:
    //   Container(
    //     decoration: BoxDecoration(
    //       border: Border(left: BorderSide(color: MpColors.border.selected, width: 2)),
    //     ),
    //     child: MpListTileX(
    //       backgroundColor: MpColors.bg.subtle,
    //       leading: MpIconAvatar(icon: MpIcons.*, backgroundColor: MpColors.bg.*),
    //       content: MpListTileXContent.double(label: title, caption: subtitle + timestamp),
    //       trailing: Container(8, 8, decoration: circle, color: MpColors.bg.brandBold),
    //     ),
    //   )
    //
    // READ item:
    //   MpListTileX(
    //     backgroundColor: MpColors.bg.stage,
    //     leading: MpIconAvatar(...),
    //     content: MpListTileXContent.double(...),
    //   )
    //
    // SWIPE to dismiss (no Pixel component — use Flutter Dismissible):
    //   Dismissible(
    //     key: Key(notifId),
    //     direction: DismissDirection.endToStart,
    //     background: Container(
    //       color: MpColors.bg.successBold,
    //       alignment: Alignment.centerRight,
    //       padding: EdgeInsets.only(right: MpSpacing.medium),
    //       child: Row([Icon(Icons.check, color: white), Text('Mark as read', style: inverse)]),
    //     ),
    //     onDismissed: (_) { /* mark as read */ },
    //     child: _notifItem,
    //   )
    //
    // Icon avatar color by notification type:
    //   Claim approved  → MpColors.bg.success    (green)
    //   Claim rejected  → MpColors.bg.danger     (red)
    //   Payment         → MpColors.bg.warning    (yellow)
    //   Trip            → MpColors.bg.highlight  (violet)
    //   Comment         → MpColors.bg.brand      (blue)

    // TODO: implement with real notification data
    return const SizedBox.shrink();
  }
}
