// ============================================================
// FilterSheet — Filter bottom sheet
// Prototype : #sheet-filter in my-requests.html
// Design spec: DESIGN.md §11.11
// ============================================================
// MpBottomSheet.show() + MpBottomSheetContent
//   header: MpBottomSheetHeader(title: Text('Filter'))
//   body: Column([
//     period MpSingleFilter (This month / Last month / Custom)
//     status MpSingleFilter (All / Awaiting approval / Disbursed / Rejected)
//     amount range: Row([MpTextField(min), MpTextField(max)])
//   ])
//   footer: MpActionGroup([MpButton.ghost('Reset'), MpButton.primary('Apply')])
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class FilterSheet {
  FilterSheet._();

  static Future<void> show(BuildContext context) {
    return MpBottomSheet.show(
      context,
      builder: (ctx) => _FilterSheetContent(onClose: () => Navigator.pop(ctx)),
    );
  }
}

class _FilterSheetContent extends StatefulWidget {
  final VoidCallback onClose;
  const _FilterSheetContent({required this.onClose});

  @override
  State<_FilterSheetContent> createState() => _FilterSheetContentState();
}

class _FilterSheetContentState extends State<_FilterSheetContent> {
  int _selectedPeriod = 0;
  int _selectedStatus = 0;
  final _minController = TextEditingController();
  final _maxController = TextEditingController();

  final _periods = const [
    MpSingleFilterTagData(label: 'This month'),
    MpSingleFilterTagData(label: 'Last month'),
    MpSingleFilterTagData(label: 'Custom'),
  ];

  final _statuses = const [
    MpSingleFilterTagData(label: 'All'),
    MpSingleFilterTagData(label: 'Awaiting approval'),
    MpSingleFilterTagData(label: 'Disbursed'),
    MpSingleFilterTagData(label: 'Rejected'),
  ];

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MpBottomSheetContent(
      showHandlerIndicator: true,
      header: const MpBottomSheetHeader(
        title: Text('Filter'),
        implyCloseable: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Period', style: MpTextStyles.sm.semiBold),
          const SizedBox(height: MpSpacing.xSmall),
          MpSingleFilter(
            tags: _periods,
            selectedIndex: _selectedPeriod,
            onTapTag: (i) => setState(() => _selectedPeriod = i),
          ),
          const SizedBox(height: MpSpacing.medium),
          Text('Status', style: MpTextStyles.sm.semiBold),
          const SizedBox(height: MpSpacing.xSmall),
          MpSingleFilter(
            tags: _statuses,
            selectedIndex: _selectedStatus,
            onTapTag: (i) => setState(() => _selectedStatus = i),
          ),
          const SizedBox(height: MpSpacing.medium),
          Text('Amount range', style: MpTextStyles.sm.semiBold),
          const SizedBox(height: MpSpacing.xSmall),
          Row(
            children: [
              Expanded(
                child: MpTextField(
                  label: 'Min',
                  hint: 'Rp 0',
                  controller: _minController,
                  prefix: const Text('Rp'),
                  textInputType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              const SizedBox(width: MpSpacing.small),
              Expanded(
                child: MpTextField(
                  label: 'Max',
                  hint: 'Rp 0',
                  controller: _maxController,
                  prefix: const Text('Rp'),
                  textInputType: const TextInputType.numberWithOptions(decimal: true),
                ),
              ),
            ],
          ),
        ],
      ),
      footer: MpActionGroup(
        actions: [
          MpButton.ghost(
            label: 'Reset',
            onPressed: () {
              setState(() {
                _selectedPeriod = 0;
                _selectedStatus = 0;
                _minController.clear();
                _maxController.clear();
              });
            },
          ),
          MpButton.primary(
            label: 'Apply',
            onPressed: () {
              // TODO: apply filter and close
              widget.onClose();
            },
          ),
        ],
      ),
    );
  }
}
