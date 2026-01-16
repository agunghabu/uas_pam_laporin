import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporin'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Pending', icon: Icon(Icons.warning_amber_rounded)),
              Tab(text: 'Active', icon: Icon(Icons.hourglass_empty)),
              Tab(text: 'Completed', icon: Icon(Icons.done_all)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
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
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Broken AC in G3-R1', style: Theme.of(context).textTheme.headlineSmall),
                            SizedBox(height: 8),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.person_outline_rounded, size: 16),
                                    SizedBox(width: 4),
                                    Text('habuhenka', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('2024-06-15', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.access_time_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('14:30', style: Theme.of(context).textTheme.bodyMedium),
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
                                    Text('Campus A', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                                Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                Row(
                                  children: [
                                    Icon(Icons.apartment_outlined, size: 16),
                                    SizedBox(width: 4),
                                    Text('G3-R1', style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Text(
                              'The AC has been leaking water for two days.',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton.icon(
                                  onPressed: () {},
                                  label: Text('Reject'),
                                  icon: Icon(Icons.close_rounded),
                                ),
                                FilledButton(onPressed: () {}, child: Text('See details')),
                                TextButton.icon(
                                  onPressed: () {},
                                  label: Text('Accept'),
                                  icon: Icon(Icons.check_rounded),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Center(child: Text('Active')),
            Center(child: Text('Completed')),
          ],
        ),
      ),
    );
  }
}
