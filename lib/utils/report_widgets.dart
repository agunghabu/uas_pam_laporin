import 'package:flutter/material.dart';
import 'package:uas_pam_laporin/services/api_service.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

class ReportCard extends StatelessWidget {
  final Map<String, dynamic> report;
  final Widget actionSection;

  const ReportCard({super.key, required this.report, required this.actionSection});

  @override
  Widget build(BuildContext context) {
    final imageUrl = '${ApiService.baseUrl}/uploads/${report['image']}';
    final createdAt = DateTime.parse(report['created_at']);
    final date =
        '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
    final time = '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

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
                            ClipRRect(borderRadius: BorderRadius.circular(6), child: Image.network(imageUrl)),
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
                actionSection,
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReportListView extends StatelessWidget {
  final List<Map<String, dynamic>> reports;
  final bool isLoading;
  final String emptyMessage;
  final Future<void> Function() onRefresh;
  final Widget Function(Map<String, dynamic> report) actionBuilder;

  const ReportListView({
    super.key,
    required this.reports,
    required this.isLoading,
    required this.emptyMessage,
    required this.onRefresh,
    required this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (reports.isEmpty) {
      return Center(child: LText.bodyMedium(context, emptyMessage));
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemCount: reports.length,
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemBuilder: (context, index) {
          final report = reports[index];
          return ReportCard(report: report, actionSection: actionBuilder(report));
        },
      ),
    );
  }
}

class PendingActionButtons extends StatelessWidget {
  final Map<String, dynamic> report;
  final Future<void> Function(int id, String status) onUpdateStatus;

  const PendingActionButtons({super.key, required this.report, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => LAlertDialog(
                icon: Icons.warning_amber_rounded,
                title: 'Reject Report',
                content: Text('Are you sure you want to reject this report? This action cannot be undone.'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('Reject')),
                ],
              ),
            );
            if (confirm == true) {
              await onUpdateStatus(report['id'], 'rejected');
            }
          },
          label: Text('Reject'),
          icon: Icon(Icons.close_rounded),
        ),
        FilledButton.icon(
          onPressed: () async {
            await onUpdateStatus(report['id'], 'active');
          },
          label: Text('Accept'),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}

class ActiveActionButtons extends StatelessWidget {
  final Map<String, dynamic> report;
  final Future<void> Function(int id, String status) onUpdateStatus;

  const ActiveActionButtons({super.key, required this.report, required this.onUpdateStatus});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => LAlertDialog(
                icon: Icons.warning_amber_rounded,
                title: 'Reject Report',
                content: Text('Are you sure you want to reject this report?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
                  FilledButton(onPressed: () => Navigator.pop(context, true), child: Text('Reject')),
                ],
              ),
            );
            if (confirm == true) {
              await onUpdateStatus(report['id'], 'rejected');
            }
          },
          label: Text('Reject'),
          icon: Icon(Icons.close_rounded),
        ),
        FilledButton.icon(
          onPressed: () async {
            await onUpdateStatus(report['id'], 'completed');
          },
          label: Text('Complete'),
          icon: Icon(Icons.check_rounded),
        ),
      ],
    );
  }
}

class CompletedStatusBadge extends StatelessWidget {
  const CompletedStatusBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(Icons.done_all, size: 16), SizedBox(width: 4), LText.bodyMedium(context, 'Completed')],
          ),
        ),
      ),
    );
  }
}

class UserStatusBadge extends StatelessWidget {
  final String status;

  const UserStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    IconData statusIcon;
    String statusText;

    if (status == 'active') {
      statusText = 'Active';
      statusIcon = Icons.hourglass_empty;
    } else if (status == 'completed') {
      statusText = 'Completed';
      statusIcon = Icons.done_all;
    } else if (status == 'rejected') {
      statusText = 'Rejected';
      statusIcon = Icons.close_rounded;
    } else {
      statusText = 'Pending';
      statusIcon = Icons.schedule;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Icon(statusIcon, size: 16), SizedBox(width: 4), LText.bodyMedium(context, statusText)],
          ),
        ),
      ),
    );
  }
}
