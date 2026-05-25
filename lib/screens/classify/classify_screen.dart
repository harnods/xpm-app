// ============================================================
// ClassifyScreen — XPM Mobile (AI Category Classification)
// Prototype : classify.html
// Design spec: DESIGN.md §11.6
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar(title: 'Classify expense', leading: back)
//   └─ stage:
//       ├─ MpBanner.info          AI suggestion banner
//       ├─ _ReceiptThumb          ClipRRect(Image) + page count badge
//       ├─ _CategoryList          MpListTileX per category + Radio trailing
//       │   selected → MpListTileX(backgroundColor: MpColors.bg.brand, Radio selected)
//       │   unselected → MpListTileX(Radio unselected)
//       ├─ MpButton.primary       Confirm
//       └─ MpButton.ghost         Edit manually
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';

class ClassifyScreen extends StatefulWidget {
  const ClassifyScreen({super.key});

  static const routeName = '/classify';

  @override
  State<ClassifyScreen> createState() => _ClassifyScreenState();
}

class _ClassifyScreenState extends State<ClassifyScreen> {
  int _selectedCategoryIndex = 0;

  // TODO: replace with real categories from API
  final List<_CategoryItem> _categories = const [
    _CategoryItem(label: 'Transport claim', iconColor: Colors.green),
    _CategoryItem(label: 'Meals & Entertainment', iconColor: Colors.orange),
    _CategoryItem(label: 'Accommodation', iconColor: Colors.blue),
    _CategoryItem(label: 'Subscription', iconColor: Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: 'Classify expense',
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      stage: [
        // AI suggestion banner
        MpContent(
          child: MpBanner.info(
            title: 'AI suggestion',
            message: 'We detected this as Transport. Is that correct?',
          ),
        ),

        // Receipt thumbnail — DESIGN.md §11.6
        // ClipRRect(borderRadius: MpRadius.medium, child: Image.file)
        // Custom badge overlay: '1/3' on top-right corner
        MpContent(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(MpRadius.medium),
                child: const Placeholder(fallbackHeight: 160), // TODO: real Image
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: MpColors.bg.inverse,
                    borderRadius: BorderRadius.circular(MpRadius.full),
                  ),
                  child: Text('1/3', style: MpTextStyles.xxs.copyWith(color: MpColors.text.inverse)),
                ),
              ),
            ],
          ),
        ),

        // Category list
        MpContent(
          child: Column(
            children: List.generate(_categories.length, (index) {
              final cat = _categories[index];
              final isSelected = index == _selectedCategoryIndex;
              return MpListTileX(
                backgroundColor: isSelected
                    ? MpColors.bg.brand.resolve(context)
                    : MpColors.bg.stage.resolve(context),
                leading: MpIconAvatar(
                  icon: MpIcons.feature.document, // TODO: use category-specific icon
                  backgroundColor: cat.iconColor.withOpacity(0.1),
                ),
                content: Text(cat.label, style: MpTextStyles.sm),
                trailing: Radio<int>(
                  value: index,
                  groupValue: _selectedCategoryIndex,
                  onChanged: (v) => setState(() => _selectedCategoryIndex = v!),
                ),
                onTap: () => setState(() => _selectedCategoryIndex = index),
              );
            }),
          ),
        ),

        // Actions
        MpContent(
          child: MpButton.primary(
            label: 'Confirm',
            onPressed: () {
              // TODO: confirm selected category and navigate back
              Navigator.of(context).pop(_categories[_selectedCategoryIndex].label);
            },
          ),
        ),
        MpContent(
          child: MpButton.ghost(
            label: 'Edit manually',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }
}

class _CategoryItem {
  final String label;
  final Color iconColor;
  const _CategoryItem({required this.label, required this.iconColor});
}
