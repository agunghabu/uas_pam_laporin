import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/login.dart';
import 'package:uas_pam_laporin/provider/provider_login.dart';
import 'package:uas_pam_laporin/provider/provider_reports.dart';
import 'package:uas_pam_laporin/provider/provider_theme.dart';
import 'package:uas_pam_laporin/utils/helpers.dart';
import 'package:uas_pam_laporin/utils/report_widgets.dart';

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
                return ReportListView(
                  reports: provider.pendingReports,
                  isLoading: provider.isLoadingAdmin,
                  emptyMessage: 'No pending reports',
                  onRefresh: () => provider.fetchReportsByStatus('pending'),
                  actionBuilder: (report) => PendingActionButtons(
                    report: report,
                    onUpdateStatus: (id, status) => provider.updateReportStatus(id, status),
                  ),
                );
              },
            ),
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                return ReportListView(
                  reports: provider.activeReports,
                  isLoading: provider.isLoadingAdmin,
                  emptyMessage: 'No active reports',
                  onRefresh: () => provider.fetchReportsByStatus('active'),
                  actionBuilder: (report) => ActiveActionButtons(
                    report: report,
                    onUpdateStatus: (id, status) => provider.updateReportStatus(id, status),
                  ),
                );
              },
            ),
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                return ReportListView(
                  reports: provider.completedReports,
                  isLoading: provider.isLoadingAdmin,
                  emptyMessage: 'No completed reports',
                  onRefresh: () => provider.fetchReportsByStatus('completed'),
                  actionBuilder: (report) => CompletedStatusBadge(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
