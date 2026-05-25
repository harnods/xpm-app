// ============================================================
// ReceiptPreviewScreen — XPM Mobile
// Prototype : receipt-preview.html
// Design spec: DESIGN.md §11.7
// ============================================================
// Widget tree:
//   Scaffold (NOT MpBasicLayout — dark overlay)
//   ├─ appBar: MpBaseAppBar(transparent, leading: close MpIconButton)
//   └─ body: Column
//       ├─ InteractiveViewer(child: Image)   pinch-to-zoom — no Pixel equivalent
//       ├─ page indicator (Custom Row of dots or Text '1/3')
//       └─ thumbnail strip (ListView.builder horizontal)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class ReceiptPreviewScreen extends StatefulWidget {
  const ReceiptPreviewScreen({super.key});

  static const routeName = '/receipt-preview';

  @override
  State<ReceiptPreviewScreen> createState() => _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends State<ReceiptPreviewScreen> {
  int _currentPage = 0;
  // TODO: receive image list via GoRouter extra or constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: MpBaseAppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.x,
          iconColor: MpColors.text.inverse,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Main image viewer — pinch-to-zoom (no Pixel equivalent)
          Expanded(
            child: InteractiveViewer(
              child: Center(
                child: const Placeholder(), // TODO: Image.network(imageUrls[_currentPage])
              ),
            ),
          ),

          // Page indicator "1/3"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              '${_currentPage + 1}/1', // TODO: replace 1 with real total
              style: MpTextStyles.sm.copyWith(color: MpColors.text.inverse),
            ),
          ),

          // Thumbnail strip
          SizedBox(
            height: 64,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 1, // TODO: real image count
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _currentPage = index),
                  child: Container(
                    width: 64,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      border: _currentPage == index
                          ? Border.all(
                              color: MpColors.border.selected,
                              width: 2,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(MpRadius.small),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(MpRadius.small),
                      child: const Placeholder(), // TODO: Image.network(thumb)
                    ),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}
