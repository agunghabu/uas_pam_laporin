import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/pages/login.dart';
import 'package:uas_pam_laporin/provider/provider_login.dart';
import 'package:uas_pam_laporin/provider/provider_reports.dart';
import 'package:uas_pam_laporin/provider/provider_theme.dart';
import 'package:uas_pam_laporin/services/csv_service.dart';
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
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Laporin'),
          actions: [
            InkWell(
              onTap: () async {
                final provider = context.read<ProviderReports>();
                final filePath = await CsvService.exporToCsv(
                  pendingReports: provider.pendingReports,
                  activeReports: provider.activeReports,
                  completedReports: provider.completedReports,
                  rejectedReports: provider.rejectedReports,
                );

                if (context.mounted) {
                  if (filePath != null) {
                    showDialog(
                      context: context,
                      builder: (context) => LAlertDialog(
                        icon: Icons.check_rounded,
                        title: 'Export Successful',
                        content: LText.bodyMedium(
                          context,
                          'CSV file saved to "Download" folder:\n$filePath',
                          textAlign: TextAlign.center,
                        ),
                        actions: [FilledButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => LAlertDialog(
                        icon: Icons.error_outline,
                        title: 'Export Failed',
                        content: LText.bodyMedium(
                          context,
                          'No reports to export or failed to save file.',
                          textAlign: TextAlign.center,
                        ),
                        actions: [FilledButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
                      ),
                    );
                  }
                }
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(shape: BoxShape.circle),
                child: Icon(Icons.save_outlined, size: 26),
              ),
            ),
            SizedBox(width: 8),
            InkWell(
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
              borderRadius: BorderRadius.circular(24),
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
              Tab(text: 'Dashboard', icon: Icon(Icons.dashboard_rounded)),
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
                final totalCount =
                    provider.pendingReports.length +
                    provider.activeReports.length +
                    provider.completedReports.length +
                    provider.rejectedReports.length;
                final pendingCount = provider.pendingReports.length;
                final activeCount = provider.activeReports.length;
                final completedCount = provider.completedReports.length;
                final rejectedCount = provider.rejectedReports.length;

                return RefreshIndicator(
                  onRefresh: () async {
                    await provider.fetchReportsByStatus('pending');
                    await provider.fetchReportsByStatus('active');
                    await provider.fetchReportsByStatus('completed');
                    await provider.fetchReportsByStatus('rejected');
                  },
                  child: ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context
                              .watch<ProviderAppTheme>()
                              .colors[context.watch<ProviderAppTheme>().colorIndex]
                              .withOpacity(0.15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.send_and_archive_outlined, size: 32),
                                    SizedBox(height: 12),
                                    LText.headlineSmall(context, 'Total Reports'),
                                    SizedBox(height: 4),
                                    LText.bodySmall(context, 'All submitted reports', textAlign: TextAlign.start),
                                  ],
                                ),
                              ),
                              Text('$totalCount', style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: LStatusCard(
                              icon: Icons.warning_amber_rounded,
                              color: Colors.orange,
                              title: 'Pending',
                              count: pendingCount,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: LStatusCard(
                              icon: Icons.hourglass_empty,
                              color: Colors.blue,
                              title: 'Active',
                              count: activeCount,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: LStatusCard(
                              icon: Icons.done_all,
                              color: Colors.green,
                              title: 'Completed',
                              count: completedCount,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: LStatusCard(
                              icon: Icons.close_rounded,
                              color: Colors.red,
                              title: 'Rejected',
                              count: rejectedCount,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
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
