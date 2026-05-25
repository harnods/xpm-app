// ============================================================
// CreateReportScreen — XPM Mobile
// Prototype : create-report.html
// Design spec: DESIGN.md §11.10
// ============================================================
// Widget tree:
//   MpBasicLayout (no bottomNavigationBar)
//   ├─ appBar: MpTextAppBar(title: 'Create report', leading: back)
//   └─ stage:
//       ├─ MpListTileX        trip summary (leading: MpIconAvatar, trailing: total)
//       ├─ MpTextField        Report name (required)
//       ├─ MpTextField        Notes / purpose (minLines: 3)
//       ├─ MpButton.primary   Submit report
//       └─ MpButton.ghost     Cancel
// ============================================================

import 'package:flutter/material.dart';
import 'package:mekari_pixel/mekari_pixel.dart';

import '../../core/theme/xpm_colors.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  static const routeName = '/create-report';

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MpBasicLayout(
      backgroundColor: XpmColors.bgBase,
      appBar: MpTextAppBar(
        title: 'Create report',
        leading: MpIconButton(
          icon: MpIcons.interfaceEssential.arrowLeft,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      stage: [
        // Trip summary tile — DESIGN.md §11.10
        MpContent(
          child: MpListTileX(
            leading: MpIconAvatar(
              icon: MpIcons.feature.airplane,
              backgroundColor: MpColors.bg.highlight,
            ),
            content: MpListTileXContent.double(
              label: 'Business trip · Surabaya', // TODO: real trip name
              caption: '12 Jun – 16 Jun 2023 · 4 expenses',
            ),
            trailing: Text(
              'Rp1.200.000',
              style: MpTextStyles.sm.semiBold.copyWith(
                color: MpColors.text.primary.resolve(context),
              ),
            ),
          ),
        ),

        MpContent(
          child: MpTextField(
            label: 'Report name',
            hint: 'e.g. Business trip Surabaya June 2023',
            controller: _nameController,
            required: true,
          ),
        ),
        MpContent(
          child: MpTextField(
            label: 'Notes / purpose',
            hint: 'Describe the purpose of this trip',
            controller: _notesController,
            minLines: 3,
            maxLines: 5,
          ),
        ),
        MpContent(
          child: MpButton.primary(
            label: 'Submit report',
            onPressed: () {
              // TODO: validate and submit report
              // On success: show success MpToast and pop
              MpToast.done('Report submitted successfully').show(context);
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
