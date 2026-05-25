// ============================================================
// CategorySheet — Category picker bottom sheet
// Prototype : #sheet-category in reimb-form.html, trip-form.html, classify.html
// Design spec: DESIGN.md §11.11
// ============================================================
// MpBottomSheet.show() + MpBottomSheetContent
//   header: MpSearch(hint: 'Search category')
//   body: ListView(MpListTileX per category, trailing: Radio)
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

class CategorySheet {
  CategorySheet._();

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<String> onSelected,
  }) {
    return MpBottomSheet.show(
      context,
      builder: (ctx) => _CategorySheetContent(
        onSelected: (cat) {
          Navigator.pop(ctx);
          onSelected(cat);
        },
      ),
    );
  }
}

class _CategorySheetContent extends StatefulWidget {
  final ValueChanged<String> onSelected;
  const _CategorySheetContent({required this.onSelected});

  @override
  State<_CategorySheetContent> createState() => _CategorySheetContentState();
}

class _CategorySheetContentState extends State<_CategorySheetContent> {
  String _query = '';

  // TODO: replace with real categories from API
  static const _allCategories = [
    ('Transport claim', MpColors.bg.success),
    ('Meals & Entertainment', MpColors.bg.warning),
    ('Accommodation', MpColors.bg.highlight),
    ('Subscription', MpColors.bg.brand),
    ('Office supplies', MpColors.bg.brand),
    ('Training & Conference', MpColors.bg.highlight),
  ];

  List<(String, Color)> get _filtered => _allCategories
      .where((c) => c.$1.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return MpBottomSheetContent(
      showHandlerIndicator: true,
      header: MpSearch(
        hintText: 'Search category',
        onTextChanged: (q) => setState(() => _query = q),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: _filtered.length,
        itemBuilder: (_, index) {
          final (label, bgColor) = _filtered[index];
          return MpListTileX(
            leading: MpIconAvatar(
              icon: MpIcons.feature.document, // TODO: category-specific icon
              backgroundColor: bgColor.resolve(context),
            ),
            content: Text(label, style: MpTextStyles.sm),
            onTap: () => widget.onSelected(label),
          );
        },
      ),
    );
  }
}
