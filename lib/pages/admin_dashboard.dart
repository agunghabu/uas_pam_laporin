import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/login.dart';
import 'package:uas_pam_laporin/provider/provider_login.dart';
import 'package:uas_pam_laporin/provider/provider_reports.dart';
import 'package:uas_pam_laporin/provider/provider_theme.dart';
import 'package:uas_pam_laporin/services/api_service.dart';
import 'package:uas_pam_laporin/utils/helpers.dart';

import '../utils/widgets.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProviderReports>().fetchReportsByStatus('pending');
      context.read<ProviderReports>().fetchReportsByStatus('active');
      context.read<ProviderReports>().fetchReportsByStatus('completed');
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporin'),
          actions: [
            InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => LAlertDialog(
                    icon: Icons.category_outlined,
                    title: 'Extras',
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<ProviderLogin>().logout();
                          context.read<ProviderReports>().clearAdminReports();
                          pushReplace(context, Login());
                        },
                        child: Text('Logout'),
                      ),
                      FilledButton(onPressed: () => Navigator.pop(context), child: Text('OK')),
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.person_outline_rounded, size: 16),
                                SizedBox(width: 4),
                                LText.bodyMedium(context, context.read<ProviderLogin>().userData?['name'] ?? ''),
                              ],
                            ),
                            Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                            Row(
                              children: [
                                Icon(Icons.numbers_rounded, size: 16),
                                SizedBox(width: 4),
                                LText.bodyMedium(context, context.read<ProviderLogin>().userData?['user_id'] ?? ''),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Divider(),
                        Row(
                          children: [
                            Icon(Icons.dark_mode_outlined, size: 30),
                            SizedBox(width: 16),
                            LText.bodyMedium(context, 'Dark Mode'),
                            Spacer(),
                            Switch(
                              value: context.watch<ProviderAppTheme>().darkMode,
                              onChanged: (value) {
                                context.read<ProviderAppTheme>().setDarkMode(value);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Icon(Icons.color_lens_outlined, size: 30),
                            SizedBox(width: 16),
                            LDropdownMenu(
                              onSelected: (value) => context.read<ProviderAppTheme>().setColorIndex(value ?? 0),
                              menuHeight: 200,
                              labelText: 'Color Theme',
                              initialSelection: context.read<ProviderAppTheme>().colorIndex,
                              dropdownMenuEntries: context.read<ProviderAppTheme>().colorDropdownItems,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Icon(Icons.category_outlined, size: 26),
              ),
            ),
            SizedBox(width: 8),
          ],
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
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                if (provider.isLoadingAdmin) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.pendingReports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                        SizedBox(height: 16),
                        LText.bodyMedium(context, 'No pending reports'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ProviderReports>().fetchReportsByStatus('pending');
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: provider.pendingReports.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final report = provider.pendingReports[index];
                      final imageUrl = '${ApiService.baseUrl}/uploads/${report['image']}';
                      final createdAt = DateTime.parse(report['created_at']);
                      final date =
                          '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
                      final time =
                          '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                        child: Center(child: Icon(Icons.broken_image_outlined, size: 48)),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: IconButton.filledTonal(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(imageUrl),
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
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LText.headlineSmall(context, report['title'] ?? ''),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline_rounded, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['user_name'] ?? report['user_id'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, date),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, time),
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
                                          LText.bodyMedium(context, report['area'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.apartment_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['unit'] ?? ''),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  if (report['description'] != null && report['description'].toString().isNotEmpty)
                                    LText.bodySmall(context, report['description'], textAlign: TextAlign.center),
                                  SizedBox(height: 4),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {},
                                        label: Text('Reject'),
                                        icon: Icon(Icons.close_rounded),
                                      ),
                                      FilledButton.icon(
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
                      );
                    },
                  ),
                );
              },
            ),
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                if (provider.isLoadingAdmin) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.activeReports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                        SizedBox(height: 16),
                        LText.bodyMedium(context, 'No active reports'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ProviderReports>().fetchReportsByStatus('active');
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: provider.activeReports.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final report = provider.activeReports[index];
                      final imageUrl = '${ApiService.baseUrl}/uploads/${report['image']}';
                      final createdAt = DateTime.parse(report['created_at']);
                      final date =
                          '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
                      final time =
                          '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                        child: Center(child: Icon(Icons.broken_image_outlined, size: 48)),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: IconButton.filledTonal(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(imageUrl),
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
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(12, 12, 12, 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LText.headlineSmall(context, report['title'] ?? ''),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline_rounded, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['user_name'] ?? report['user_id'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, date),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, time),
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
                                          LText.bodyMedium(context, report['area'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.apartment_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['unit'] ?? ''),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  if (report['description'] != null && report['description'].toString().isNotEmpty)
                                    LText.bodySmall(context, report['description'], textAlign: TextAlign.center),
                                  SizedBox(height: 4),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      TextButton.icon(
                                        onPressed: () {},
                                        label: Text('Discard'),
                                        icon: Icon(Icons.close_rounded),
                                      ),
                                      FilledButton.icon(
                                        onPressed: () {},
                                        label: Text('Complete'),
                                        icon: Icon(Icons.check_rounded),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                if (provider.isLoadingAdmin) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.completedReports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                        SizedBox(height: 16),
                        LText.bodyMedium(context, 'No completed reports'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await context.read<ProviderReports>().fetchReportsByStatus('completed');
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: provider.completedReports.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final report = provider.completedReports[index];
                      final imageUrl = '${ApiService.baseUrl}/uploads/${report['image']}';
                      final createdAt = DateTime.parse(report['created_at']);
                      final date =
                          '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
                      final time =
                          '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 220,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                                        child: Center(child: Icon(Icons.broken_image_outlined, size: 48)),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 4,
                                  bottom: 4,
                                  child: IconButton.filledTonal(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => Dialog(
                                          child: Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(6),
                                                child: Image.network(imageUrl),
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
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LText.headlineSmall(context, report['title'] ?? ''),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(Icons.person_outline_rounded, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['user_name'] ?? report['user_id'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.calendar_today_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, date),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.access_time_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, time),
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
                                          LText.bodyMedium(context, report['area'] ?? ''),
                                        ],
                                      ),
                                      Text(' | ', style: Theme.of(context).textTheme.bodyMedium),
                                      Row(
                                        children: [
                                          Icon(Icons.apartment_outlined, size: 16),
                                          SizedBox(width: 4),
                                          LText.bodyMedium(context, report['unit'] ?? ''),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  if (report['description'] != null && report['description'].toString().isNotEmpty)
                                    LText.bodySmall(context, report['description'], textAlign: TextAlign.center),
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
                                          Icon(Icons.done_all, size: 16),
                                          SizedBox(width: 4),
                                          Text('Completed', style: Theme.of(context).textTheme.bodyMedium),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
