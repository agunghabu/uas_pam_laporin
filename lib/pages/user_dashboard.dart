import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome {User}')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    size: 48,
                    color: Colors.white24,
                  ),
                  Text(
                    'Tap to take photo',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return DropdownMenu(
                      width: constraints.maxWidth,
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
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 0, label: 'Campus A'),
                        DropdownMenuEntry(value: 1, label: 'Campus B'),
                        DropdownMenuEntry(value: 2, label: 'Campus C'),
                      ],
                      label: Text('Building'),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
