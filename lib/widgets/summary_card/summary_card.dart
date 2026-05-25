// ============================================================
// SummaryCard — Custom widget (no Pixel equivalent)
// Prototype : .card in home.html and my-requests.html
// Design spec: DESIGN.md §11.1
// ============================================================
// Structure:
//   Container (bg-stage, MpRadius.xLarge, MpSpacing.medium)
//   └─ Column
//       ├─ Text 'This month'         (text-secondary, sm)
//       ├─ Text total amount         (text-primary, xl.semiBold)
//       └─ Row (stat cells separated by VerticalDivider)
//           ├─ _StatCell(Pending, count, text-primary)
//           ├─ _StatCell(Awaiting payment, amount, text-warning)
//           └─ _StatCell(Disbursed, amount, icon-success)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class SummaryCard extends StatelessWidget {
  final String totalAmount;
  final int pendingCount;
  final String awaitingAmount;
  final String disbursedAmount;

  const SummaryCard({
    super.key,
    required this.totalAmount,
    required this.pendingCount,
    required this.awaitingAmount,
    required this.disbursedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(MpSpacing.medium),
      decoration: BoxDecoration(
        color: MpColors.bg.stage.resolve(context),
        borderRadius: BorderRadius.circular(MpRadius.xLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This month',
            style: MpTextStyles.sm.copyWith(
              color: MpColors.text.secondary.resolve(context),
            ),
          ),
          const SizedBox(height: MpSpacing.xSmall4),
          Text(
            totalAmount,
            style: MpTextStyles.xl.semiBold.copyWith(
              color: MpColors.text.primary.resolve(context),
            ),
          ),
          const SizedBox(height: MpSpacing.small),
          IntrinsicHeight(
            child: Row(
              children: [
                _StatCell(
                  label: 'Pending',
                  value: '$pendingCount claims',
                  valueColor: MpColors.text.primary.resolve(context),
                ),
                VerticalDivider(color: MpColors.border.subtle.resolve(context)),
                _StatCell(
                  label: 'Awaiting payment',
                  value: awaitingAmount,
                  valueColor: MpColors.text.warning.resolve(context),
                ),
                VerticalDivider(color: MpColors.border.subtle.resolve(context)),
                _StatCell(
                  label: 'Disbursed',
                  value: disbursedAmount,
                  valueColor: MpColors.icon.success.resolve(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatCell({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: MpSpacing.xSmall),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: MpTextStyles.xxs.copyWith(
                color: MpColors.text.secondary.resolve(context),
              ),
            ),
            const SizedBox(height: MpSpacing.xSmall4),
            Text(
              value,
              style: MpTextStyles.sm.semiBold.copyWith(color: valueColor),
            ),
          ],
        ),
      ),
    );
  }
}
