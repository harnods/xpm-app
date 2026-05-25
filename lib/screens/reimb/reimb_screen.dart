// ============================================================
// ReimbScreen — XPM Mobile (Receipt Scan / Camera)
// Prototype : reimb.html
// Design spec: DESIGN.md §11.4
// ============================================================
// ⚠️  This screen is mostly prototype chrome (DESIGN.md §6).
//     The camera viewfinder is OS-provided via CameraPreview.
//
// Widget tree:
//   Scaffold (NOT MpBasicLayout — dark full-screen)
//   ├─ body: Stack
//   │   ├─ CameraPreview (full-screen, camera package)
//   │   ├─ top-left: MpIconButton(close, color: text-inverse)
//   │   ├─ top-right: Custom credits chip (bg-inverse, MpRadius.full)
//   │   ├─ center: Custom CustomPaint (4 corner brackets)
//   │   ├─ center-bottom: Text hint ('Align the receipt inside the frame')
//   │   ├─ bottom-center: MpButton.ghost('Fill manually instead')
//   │   ├─ bottom-left: MpIconButton(gallery) + Text('Browse')
//   │   └─ bottom-center: Custom shutter button (white circle 64×64)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../reimb_form/reimb_form_screen.dart';

class ReimbScreen extends StatelessWidget {
  const ReimbScreen({super.key});

  static const routeName = '/reimb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115), // DESIGN.md §6: prototype chrome dark
      body: Stack(
        children: [
          // 1. Camera viewfinder — OS-provided (CameraPreview from camera package)
          // TODO: initialize CameraController and display CameraPreview here

          // 2. Close button (top-left)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: MpIconButton(
              icon: MpIcons.interfaceEssential.x,
              iconColor: MpColors.text.inverse,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // 3. AI credits chip (top-right) — Custom, no Pixel equivalent
          // DESIGN.md §10.12: bg-inverse, text-inverse, MpRadius.full
          // TODO: replace hardcoded count with real credits remaining
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: MpColors.bg.inverse,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, color: MpColors.text.inverse, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '12 AI credits left',
                    style: MpTextStyles.xs.copyWith(color: MpColors.text.inverse),
                  ),
                ],
              ),
            ),
          ),

          // 4. Scan frame corners — Custom CustomPaint
          // TODO: implement _ScanFramePainter that draws 4 corner brackets only

          // 5. Hint text
          const Align(
            alignment: Alignment(0, 0.6),
            child: Text(
              'Align the receipt inside the frame',
              style: TextStyle(color: Colors.white70),
            ),
          ),

          // 6. Bottom controls
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Gallery browse
                Column(
                  children: [
                    MpIconButton(
                      icon: MpIcons.file.image,
                      iconColor: MpColors.text.inverse,
                      onPressed: () {
                        // TODO: open image_picker gallery
                      },
                    ),
                    Text(
                      'Browse',
                      style: MpTextStyles.xs.copyWith(color: MpColors.text.inverse),
                    ),
                  ],
                ),

                // Shutter button — Custom
                GestureDetector(
                  onTap: () {
                    // TODO: capture photo with CameraController
                    // then navigate to ReimbFormScreen(fromScan: true)
                    context.push(ReimbFormScreen.routeName);
                  },
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                // Flash toggle
                MpIconButton(
                  icon: MpIcons.weather.lightning,
                  iconColor: MpColors.text.inverse,
                  onPressed: () {
                    // TODO: toggle flash with CameraController
                  },
                ),
              ],
            ),
          ),

          // "Fill manually" button
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 100,
            left: 0,
            right: 0,
            child: Center(
              child: MpButton.ghost(
                label: 'Fill manually instead',
                // TODO: override text color to white — check MpButton.ghost style API
                onPressed: () => context.push(ReimbFormScreen.routeName),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
