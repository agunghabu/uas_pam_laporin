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
    return Scaffold(
      appBar: AppBar(title: Text('Welcome {User}')),
      body: ListView(
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
                              FilledButton.icon(
                                onPressed: () async {
                                  imageFile = await takePhoto(_picker);
                                  setState(() {});
                                },
                                label: Text('Retake'),
                                icon: Icon(Icons.camera_alt_outlined),
                              ),
                              IconButton(
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
                                            child: IconButton(
                                              onPressed: () => Navigator.pop(context),
                                              style: IconButton.styleFrom(
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                              ),
                                              color: Theme.of(context).colorScheme.onPrimary,
                                              icon: Icon(Icons.close),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                style: IconButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                                color: Theme.of(context).colorScheme.onPrimary,
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
                      leadingIcon: Icons.location_on_outlined,
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
                  builder: (context) => AlertDialog(
                    icon: Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 48),
                    title: Text('Incomplete Report'),
                    content: Text(
                      'Please make sure to attach a photo, fill in the title, and select both area and unit.',
                    ),
                    actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                  ),
                );
              }
            },
            child: Text('Submit Report'),
          ),
        ],
      ),
    );
  }
}
