import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/helpers.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  File? imageFile;
  int selectedArea = -1;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome {User}')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          InkWell(
            onTap: () async {
              imageFile = await takePhoto(_picker);
              setState(() {});
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
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(imageFile!, fit: BoxFit.cover, width: double.infinity),
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.title_outlined),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Additional description\n(Optional, e.g., location details)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description_outlined),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu(
                      onSelected: (value) {
                        setState(() => selectedArea = value ?? 0);
                      },
                      initialSelection: -1,
                      width: constraints.maxWidth,
                      leadingIcon: Icon(Icons.location_on_outlined),
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 0, label: 'Campus A'),
                        DropdownMenuEntry(value: 1, label: 'Campus B'),
                        DropdownMenuEntry(value: 2, label: 'Campus C'),
                      ],
                      label: Text('Area'),
                    );
                  },
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu(
                      width: constraints.maxWidth,
                      leadingIcon: Icon(Icons.apartment_outlined),
                      dropdownMenuEntries: getBuildingEntries(selectedArea),
                      label: Text('Unit'),
                    );
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          FilledButton(onPressed: () {}, child: Text('Submit Report')),
        ],
      ),
    );
  }
}
