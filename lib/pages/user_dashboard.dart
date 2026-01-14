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
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(16),
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
                    style: TextStyle(color: Colors.white24),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
