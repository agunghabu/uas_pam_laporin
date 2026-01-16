import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

import '../utils/helpers.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  File? imageFile;
  int selectedArea = -1;
  int selectedUnit = -1;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();
  final TextEditingController unitCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome {User}'),
          actions: [TextButton(onPressed: () {}, child: Icon(Icons.bedtime_outlined, size: 24))],
          bottom: TabBar(
            tabs: [
              Tab(text: 'Submit Report', icon: Icon(Icons.send_rounded)),
              Tab(text: 'My Reports', icon: Icon(Icons.list_alt_rounded)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: [
                InkWell(
                  onTap: () async {
                    if (imageFile == null) {
                      imageFile = await takePhoto(_picker);
                      setState(() {});
                    }
                  },
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (imageFile != null) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(imageFile!, fit: BoxFit.cover, width: double.infinity),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Row(
                                  children: [
                                    FilledButton.tonalIcon(
                                      onPressed: () async {
                                        imageFile = await takePhoto(_picker);
                                        setState(() {});
                                      },
                                      label: Text('Retake'),
                                      icon: Icon(Icons.camera_alt_outlined),
                                    ),
                                    IconButton.filledTonal(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(6),
                                                  child: Image.file(imageFile!),
                                                ),
                                                Positioned(
                                                  right: 4,
                                                  top: 4,
                                                  child: IconButton.filledTonal(
                                                    onPressed: () => Navigator.pop(context),
                                                    icon: Icon(Icons.close),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.fullscreen_rounded),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_outlined, size: 48, color: Colors.white24),
                              Text('Tap to take photo', style: TextStyle(color: Theme.of(context).colorScheme.outline)),
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(height: 16),
                LTextField(
                  controller: titleCtrl,
                  icon: Icons.title_outlined,
                  labelText: "Title",
                  hintText: "e.g., Broken AC in Room 101",
                ),
                SizedBox(height: 16),
                LTextField(
                  controller: descCtrl,
                  icon: Icons.description_outlined,
                  labelText: "Additional description\n(Optional, e.g., location details, etc.)",
                  hintText: 'e.g., The AC has been leaking water for two days.',
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return LDropdownMenu(
                            onSelected: (value) => setState(() {
                              unitCtrl.clear();
                              selectedUnit = -1;
                              selectedArea = value ?? 0;
                            }),
                            labelText: 'Area',
                            width: constraints.maxWidth,
                            initialSelection: selectedArea,
                            leadingIcon: Icons.location_on_outlined,
                            dropdownMenuEntries: [
                              DropdownMenuEntry(value: 0, label: 'Campus A'),
                              DropdownMenuEntry(value: 1, label: 'Campus B'),
                              DropdownMenuEntry(value: 2, label: 'Campus C'),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return LDropdownMenu(
                            onSelected: (value) => setState(() {
                              selectedUnit = value ?? 0;
                            }),
                            labelText: 'Unit',
                            controller: unitCtrl,
                            width: constraints.maxWidth,
                            initialSelection: selectedUnit,
                            leadingIcon: Icons.apartment_outlined,
                            dropdownMenuEntries: getBuildingEntries(selectedArea),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    // print(
                    //   'Title: ${titleCtrl.text}'
                    //   'Description: ${descCtrl.text}'
                    //   'Area: $selectedArea'
                    //   'Unit: $selectedUnit',
                    // );
                    if (imageFile == null || titleCtrl.text.isEmpty || selectedArea == -1 || selectedUnit == -1) {
                      showDialog(
                        context: context,
                        builder: (context) => LAlertDialog(
                          icon: Icons.warning_amber_rounded,
                          title: 'Incomplete Report',
                          content:
                              'Please make sure to attach a photo, fill in the title, and select both area and unit.',
                          iconColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  child: Text('Submit Report'),
                ),
              ],
            ),
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 220,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://www.siliconera.com/wp-content/uploads/2025/02/wuthering-waves-version-12.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            LText.headlineSmall(context, 'Broken AC in G3-R1'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person_outline_rounded, size: 16),
                                    SizedBox(width: 4),
                                    LText.bodyMedium(context, 'habuhenka'),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 16),
                                    SizedBox(width: 4),
                                    LText.bodyMedium(context, '2024-06-15'),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_outlined, size: 16),
                                    SizedBox(width: 4),
                                    LText.bodyMedium(context, '14:30'),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.location_on_outlined, size: 16),
                                    SizedBox(width: 4),
                                    LText.bodyMedium(context, 'Campus A'),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.apartment_outlined, size: 16),
                                    SizedBox(width: 4),
                                    LText.bodyMedium(context, 'G3-R1'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            LText.bodySmall(
                              context,
                              'The AC has been leaking water for two days.',
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Divider(),
                            SizedBox(height: 4),
                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.hourglass_empty, size: 16),
                                    SizedBox(width: 4),
                                    Text('Active', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
