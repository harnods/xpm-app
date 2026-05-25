// ============================================================
// ReceiptUploadArea — Custom widget (no Pixel dropzone component)
// Prototype : .receipt-upload in reimb-form.html, trip-form.html
// Design spec: DESIGN.md §11.5
// ============================================================
// Structure:
//   GestureDetector (tap to pick image)
//   └─ DashedBorder Container (border-form color, bg-subtle)
//       └─ Column
//           ├─ Icon (upload, text-placeholder)
//           ├─ Text 'Tap to add receipt'  (text-placeholder)
//           └─ [Row of receipt thumbnails when images selected]
//
// Note: use dashed_border package or a CustomPaint for the dashed outline.
// Border color: MpColors.border.form (rgba(29,31,36,0.16))
// Background: MpColors.bg.subtle
// ============================================================

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class ReceiptUploadArea extends StatefulWidget {
  const ReceiptUploadArea({super.key});

  @override
  State<ReceiptUploadArea> createState() => _ReceiptUploadAreaState();
}

class _ReceiptUploadAreaState extends State<ReceiptUploadArea> {
  final List<XFile> _images = [];
  final _picker = ImagePicker();

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _images.add(image));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(MpSpacing.large),
        decoration: BoxDecoration(
          color: MpColors.bg.subtle.resolve(context),
          borderRadius: BorderRadius.circular(MpRadius.xLarge),
          // TODO: replace with proper DashedBorder using dashed_border package
          border: Border.all(
            color: MpColors.border.form.resolve(context),
            // dashed style requires a CustomPainter or dashed_border package
          ),
        ),
        child: _images.isEmpty ? _emptyState(context) : _thumbnailStrip(context),
      ),
    );
  }

  Widget _emptyState(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.upload_file,
          color: MpColors.text.placeholder.resolve(context),
          size: 32,
        ),
        const SizedBox(height: MpSpacing.xSmall),
        Text(
          'Tap to add receipt',
          style: MpTextStyles.sm.copyWith(
            color: MpColors.text.placeholder.resolve(context),
          ),
        ),
      ],
    );
  }

  Widget _thumbnailStrip(BuildContext context) {
    return Row(
      children: _images.map((img) {
        return Stack(
          children: [
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(right: MpSpacing.xSmall),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MpRadius.medium),
                // TODO: display actual image
                color: MpColors.bg.subtle.resolve(context),
              ),
            ),
            Positioned(
              top: 2,
              right: 6,
              child: GestureDetector(
                onTap: () => setState(() => _images.remove(img)),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: MpColors.bg.inverse.resolve(context),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 12,
                    color: MpColors.text.inverse,
                  ),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
