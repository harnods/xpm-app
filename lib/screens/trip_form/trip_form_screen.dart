// ============================================================
// TripFormScreen — XPM Mobile (Trip Expense Form)
// Prototype : trip-form.html
// Design spec: DESIGN.md §11.8
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar(title: 'New trip expense', leading: back)
//   └─ stage:
//       ├─ MpTextField  Trip selector (readOnly → trip-select MpBottomSheet)
//       ├─ MpTextField  Category (readOnly → category MpBottomSheet)
//       ├─ MpTextField  Vendor (required)
//       ├─ MpTextField  Amount (Rp prefix, number)
//       ├─ MpTextField  Date (readOnly → MpFullDatePickerSheet)
//       ├─ MpTextField  Notes (minLines: 3)
//       ├─ ReceiptUploadArea  Custom dashed-border (no Pixel dropzone)
//       ├─ MpButton.primary   Save expense
//       └─ MpButton.ghost     Cancel
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';
import '../../sheets/category_sheet.dart';
import '../../widgets/receipt_upload/receipt_upload_area.dart';

class TripFormScreen extends StatefulWidget {
  const TripFormScreen({super.key});

  static const routeName = '/trip-form';

  @override
  State<TripFormScreen> createState() => _TripFormScreenState();
}

class _TripFormScreenState extends State<TripFormScreen> {
  final _tripController = TextEditingController();
  final _categoryController = TextEditingController();
  final _vendorController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    for (final c in [_tripController, _categoryController, _vendorController,
        _amountController, _dateController, _notesController]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: 'New trip expense',
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      stage: [
        MpContent(
          child: MpTextField(
            label: 'Trip',
            hint: 'Select trip',
            controller: _tripController,
            readOnly: true,
            suffixIcon: MpIcons.interfaceEssential.chevronRight,
            onPressed: () {
              // TODO: show trip-select MpBottomSheet
            },
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Category',
            hint: 'Select category',
            controller: _categoryController,
            readOnly: true,
            suffixIcon: MpIcons.interfaceEssential.chevronRight,
            onPressed: () => CategorySheet.show(
              context,
              onSelected: (cat) => setState(() => _categoryController.text = cat),
            ),
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Vendor',
            hint: 'e.g. Grab, Hotel Santika',
            controller: _vendorController,
            required: true,
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Amount',
            hint: 'Rp 0',
            controller: _amountController,
            prefix: const Text('Rp'),
            textInputType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Date',
            hint: 'Select date',
            controller: _dateController,
            readOnly: true,
            suffixIcon: MpIcons.dateTime.calendar,
            onPressed: () async {
              await MpBottomSheet.show(
                context,
                builder: (_) => MpFullDatePickerSheet(
                  onDateSelected: (date) => Navigator.pop(context),
                ),
              );
            },
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Notes',
            hint: 'Optional',
            controller: _notesController,
            minLines: 3,
            maxLines: 5,
          ),
        ),
        MpContent(child: ReceiptUploadArea()),
        MpContent(
          child: MpButton.primary(
            label: 'Save expense',
            onPressed: () {
              // TODO: validate and save expense to trip
            },
          ),
        ),
        MpContent(
          child: MpButton.ghost(
            label: 'Cancel',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}
