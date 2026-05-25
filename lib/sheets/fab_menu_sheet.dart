// ============================================================
// FabMenuSheet — Bottom sheet triggered by FAB tap
// Prototype : #sheet-fab in home.html / my-requests.html
// Design spec: DESIGN.md §11.11
// ============================================================
// MpBottomSheet.show() + MpBottomSheetContent
//   header: MpBottomSheetHeader(title: Text('New'))
//   body: Column([
//     MpListTileX(icon, 'New expense')   → ReimbFormScreen
//     MpListTileX(icon, 'New trip')      → TripFormScreen
//     MpListTileX(icon, 'Scan receipt')  → ReimbScreen (camera)
//   ])
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../screens/reimb/reimb_screen.dart';
import '../screens/reimb_form/reimb_form_screen.dart';
import '../screens/trip_form/trip_form_screen.dart';

class FabMenuSheet {
  FabMenuSheet._();

  static Future<void> show(BuildContext context) {
    return MpBottomSheet.show(
      context,
      builder: (_) => MpBottomSheetContent(
        showHandlerIndicator: true,
        header: const MpBottomSheetHeader(
          title: Text('New'),
          implyCloseable: true,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MpListTileX(
              leading: MpIconAvatar(
                icon: MpIcons.feature.document,
                backgroundColor: MpColors.bg.brand,
              ),
              content: const Text('New expense'),
              onTap: () {
                Navigator.pop(context);
                context.push(ReimbFormScreen.routeName);
              },
            ),
            MpListTileX(
              leading: MpIconAvatar(
                icon: MpIcons.feature.airplane,
                backgroundColor: MpColors.bg.highlight,
              ),
              content: const Text('New trip'),
              onTap: () {
                Navigator.pop(context);
                context.push(TripFormScreen.routeName);
              },
            ),
            MpListTileX(
              leading: MpIconAvatar(
                icon: MpIcons.technology.camera,
                backgroundColor: MpColors.bg.subtle,
              ),
              content: const Text('Scan receipt'),
              onTap: () {
                Navigator.pop(context);
                context.push(ReimbScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
