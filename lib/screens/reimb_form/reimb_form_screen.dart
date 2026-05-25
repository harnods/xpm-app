// ============================================================
// ReimbFormScreen — XPM Mobile
// Prototype : reimb-form.html
// Design spec: DESIGN.md §11.5
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar(title: 'New expense')
//   │          leading → back MpIconButton
//   │          actions → [MpIconButton(close/X)]
//   └─ stage:
//       ├─ MpBanner.info          OCR confirmation banner (if arriving from scan)
//       ├─ MpTextField            Vendor name (required)
//       ├─ MpTextField            Amount (Rp prefix, number input)
//       ├─ MpTextField            Date (readOnly → MpFullDatePickerSheet)
//       ├─ MpTextField            Category (readOnly → category MpBottomSheet)
//       ├─ MpTextField            Notes (minLines: 3)
//       ├─ _ReceiptUploadArea     Custom dashed-border Container (no Pixel dropzone)
//       ├─ MpBanner.info          AI classify suggestion (if OCR detected category)
//       ├─ MpButton.primary       Submit
//       └─ MpButton.ghost         Cancel
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';
import '../../sheets/category_sheet.dart';
import '../../widgets/receipt_upload/receipt_upload_area.dart';

class ReimbFormScreen extends StatefulWidget {
  const ReimbFormScreen({super.key});

  static const routeName = '/reimb-form';

  /// Set to true when navigating from the camera scan screen (reimb.html)
  final bool fromScan;

  const ReimbFormScreen({super.key, this.fromScan = false});

  @override
  State<ReimbFormScreen> createState() => _ReimbFormScreenState();
}

class _ReimbFormScreenState extends State<ReimbFormScreen> {
  final _vendorController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _vendorController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: 'New expense',
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          MpIconButton(
            icon: MpIcons.interfaceEssential.x,
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          ),
        ],
      ),
      stage: [
        // DESIGN.md §11.5: OCR banner — show only when arriving from scan
        if (widget.fromScan)
          MpContent(
            child: MpBanner.info(
              message: 'Receipt scanned. Review and confirm the details.',
            ),
          ),

        // ── Form fields ─────────────────────────────────────
        MpContent(
          child: MpTextField(
            label: 'Vendor',
            hint: 'e.g. Grab, Starbucks',
            controller: _vendorController,
            required: true,
          ),
        ),
        MpContent(
          // DESIGN.md §10.13: Amount field — Rp prefix + number formatter
          child: MpTextField(
            label: 'Amount',
            hint: 'Rp 0',
            controller: _amountController,
            prefix: const Text('Rp'),
            textInputType: const TextInputType.numberWithOptions(decimal: true),
            // TODO: add CurrencyTextInputFormatter
          ),
        ),
        MpContent(
          // DESIGN.md §10.13: Date — readOnly, tap triggers MpFullDatePickerSheet
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
                  onDateSelected: (date) {
                    // TODO: format date and set _dateController.text
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        MpContent(
          // DESIGN.md §10.13: Category — readOnly, tap opens category sheet
          child: MpTextField(
            label: 'Category',
            hint: 'Select category',
            controller: _categoryController,
            readOnly: true,
            suffixIcon: MpIcons.interfaceEssential.chevronRight,
            onPressed: () => CategorySheet.show(
              context,
              onSelected: (category) {
                setState(() => _categoryController.text = category);
              },
            ),
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Notes',
            hint: 'Optional description',
            controller: _notesController,
            minLines: 3,
            maxLines: 5,
          ),
        ),

        // DESIGN.md §11.5: Custom dashed-border upload area — no Pixel dropzone
        MpContent(child: ReceiptUploadArea()),

        // DESIGN.md §11.5: AI classify banner — shown after OCR detects category
        // TODO: show conditionally based on OCR result
        MpContent(
          child: MpBanner.info(
            title: 'AI suggestion',
            message: 'We detected this as Transport. Is that correct?',
            actions: [
              MpBannerAction(
                text: 'Review',
                onTap: () {
                  // TODO: navigate to classify screen
                },
              ),
            ],
          ),
        ),

        // ── Actions ─────────────────────────────────────────
        MpContent(
          child: MpButton.primary(
            label: 'Submit',
            onPressed: () {
              // TODO: validate form and submit
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
