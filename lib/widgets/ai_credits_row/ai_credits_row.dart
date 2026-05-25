// ============================================================
// AiCreditsRow — Custom widget (no Pixel equivalent)
// Prototype : .credits-row in my-requests.html
// Design spec: DESIGN.md §10.12, §11.2
// ============================================================
// Structure:
//   Container (bg-brand, MpRadius.xLarge, MpSpacing.medium)
//   └─ Row
//       ├─ Icon (sparkle, text-link)
//       ├─ Column
//       │   ├─ Row
//       │   │   ├─ Text 'Auto-fill credits'  (text-primary, sm.semiBold)
//       │   │   └─ Text '12 remaining'       (text-link, sm)
//       │   └─ LinearProgressIndicator (bg-brandBold fill, bg-brand track)
//       └─ [optional trailing]
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class AiCreditsRow extends StatelessWidget {
  final int creditsRemaining;
  final int creditsTotal;

  const AiCreditsRow({
    super.key,
    required this.creditsRemaining,
    this.creditsTotal = 20,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = creditsRemaining / creditsTotal;
    return Container(
      padding: const EdgeInsets.all(MpSpacing.medium),
      decoration: BoxDecoration(
        color: MpColors.bg.brand.resolve(context),
        borderRadius: BorderRadius.circular(MpRadius.xLarge),
      ),
      child: Row(
        children: [
          Icon(
            Icons.auto_awesome,
            color: MpColors.text.link.resolve(context),
            size: 20,
          ),
          const SizedBox(width: MpSpacing.xSmall),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Auto-fill credits',
                      style: MpTextStyles.sm.semiBold.copyWith(
                        color: MpColors.text.primary.resolve(context),
                      ),
                    ),
                    const SizedBox(width: MpSpacing.xSmall3),
                    Text(
                      '$creditsRemaining remaining',
                      style: MpTextStyles.sm.copyWith(
                        color: MpColors.text.link.resolve(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: MpSpacing.xSmall3),
                LinearProgressIndicator(
                  value: ratio,
                  backgroundColor: MpColors.bg.brand.resolve(context),
                  color: MpColors.bg.brandBold.resolve(context),
                  borderRadius: BorderRadius.circular(999),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
