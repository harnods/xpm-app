// ============================================================
// BudgetCategoryCard — Custom widget (no Pixel equivalent)
// Prototype : .budget-card in home.html
// Design spec: DESIGN.md §9.5, §11.1
// ============================================================
// Structure:
//   Container (XpmColors.budgetCardBg, MpRadius.xLarge)
//   └─ Column
//       ├─ Text title         (text-inverse, MpTextStyles.xs.semiBold)
//       ├─ Text 'Available to spend' (text-inverse, MpTextStyles.xxs)
//       ├─ Text amount        (text-inverse, MpTextStyles.md.semiBold)
//       │   OR Text 'No limit set' (text-secondary)
//       ├─ MpProgressIndicator.percentage  (color: chart token by ratio)
//       └─ Text limit         (text-inverse, MpTextStyles.xxs)
//
// Progress fill color by spentRatio (DESIGN.md §9.5):
//   0%          → MpColors.chart.cat05Bold (neutral gray)
//   > 0, ≤ 25%  → MpColors.chart.cat02Bold (teal)
//   25% – 75%   → MpColors.chart.cat04Bold (orange)
//   > 75%       → MpColors.chart.cat06Bold (red)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';

class BudgetCategoryCard extends StatelessWidget {
  final String title;
  final String availableAmount;
  final String limitAmount;

  /// Ratio of spent / limit — 0.0 to 1.0
  final double spentRatio;

  /// True when no spending limit is set for this category
  final bool hasNoLimit;

  const BudgetCategoryCard({
    super.key,
    required this.title,
    required this.availableAmount,
    required this.limitAmount,
    required this.spentRatio,
    this.hasNoLimit = false,
  });

  Color _progressColor(BuildContext context) {
    if (hasNoLimit || spentRatio == 0) {
      return MpColors.chart.cat05Bold.resolve(context); // neutral
    } else if (spentRatio <= 0.25) {
      return MpColors.chart.cat02Bold.resolve(context); // teal — healthy
    } else if (spentRatio <= 0.75) {
      return MpColors.chart.cat04Bold.resolve(context); // orange — moderate
    } else {
      return MpColors.chart.cat06Bold.resolve(context); // red — over budget
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MpSpacing.small),
      decoration: BoxDecoration(
        color: XpmColors.budgetCardBg,
        borderRadius: BorderRadius.circular(MpRadius.xLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: MpTextStyles.xs.semiBold.copyWith(
              color: MpColors.text.inverse,
            ),
          ),
          const SizedBox(height: MpSpacing.xSmall4),

          // "Available to spend" label
          Text(
            'Available to spend',
            style: MpTextStyles.xxs.copyWith(color: MpColors.text.inverse),
          ),

          // Amount or "No limit set"
          if (hasNoLimit)
            Text(
              'No limit set',
              // DESIGN.md §9.5: NOT italic — use text-secondary
              style: MpTextStyles.sm.copyWith(color: MpColors.text.secondary.resolve(context)),
            )
          else
            Text(
              availableAmount,
              style: MpTextStyles.md.semiBold.copyWith(color: MpColors.text.inverse),
            ),

          const SizedBox(height: MpSpacing.xSmall3),

          // Progress bar — DESIGN.md §10.15: MpProgressIndicator.percentage
          // Falls back to LinearProgressIndicator if layout doesn't fit dark card
          MpProgressIndicator.percentage(
            title: '', // title already shown above
            value: (spentRatio * 100).round(),
            color: _progressColor(context),
            backgroundColor: XpmColors.budgetTrackBg,
            titleColor: Colors.transparent, // hide built-in title label
            valueColor: Colors.transparent, // hide built-in value label
          ),

          const SizedBox(height: MpSpacing.xSmall4),

          // Limit text
          if (!hasNoLimit)
            Text(
              'Limit $limitAmount',
              style: MpTextStyles.xxs.copyWith(color: MpColors.text.inverse),
            ),
        ],
      ),
    );
  }
}
