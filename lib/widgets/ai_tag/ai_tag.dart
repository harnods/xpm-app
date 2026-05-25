// ============================================================
// AiTag — Custom widget (no Pixel equivalent)
// Prototype : .ai-tag in reimb-form.html, classify.html
// Design spec: DESIGN.md §9.6
// ============================================================
// bg-brand, text-highlight (violet800), MpRadius.small
// font: MpTextStyles.xxs.semiBold, letterSpacing: 0.3px
// padding: MpSpacing.xSmall4 vertical × MpSpacing.xSmall2 horizontal
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class AiTag extends StatelessWidget {
  final String label;

  const AiTag({super.key, this.label = 'AI'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: MpSpacing.xSmall4,   // 2px
        horizontal: MpSpacing.xSmall2, // 6px
      ),
      decoration: BoxDecoration(
        color: MpColors.bg.brand.resolve(context),
        borderRadius: BorderRadius.circular(MpRadius.small),
      ),
      child: Text(
        label,
        style: MpTextStyles.xxs.semiBold.copyWith(
          color: MpColors.text.highlight.resolve(context),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
