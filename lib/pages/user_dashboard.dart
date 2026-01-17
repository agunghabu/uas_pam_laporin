import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_pam_laporin/provider/provider_login.dart';
import 'package:uas_pam_laporin/provider/provider_reports.dart';
import 'package:uas_pam_laporin/provider/provider_theme.dart';
import 'package:uas_pam_laporin/services/api_service.dart';
import 'package:uas_pam_laporin/utils/widgets.dart';

import '../provider/provider_submit_report.dart';
import '../utils/helpers.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<ProviderLogin>().userData?['user_id'] ?? '';
      context.read<ProviderReports>().fetchUserReports(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Welcome, ${context.read<ProviderLogin>().userData?['name'] ?? ''}'),
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
                      TextButton(onPressed: () => Navigator.pop(context), child: Text('Logout')),
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
                    if (context.read<ProviderSubmitReport>().imageFile == null) {
                      context.read<ProviderSubmitReport>().setImageFile(
                        await takePhoto(context.read<ProviderSubmitReport>().picker),
                      );
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
                        if (context.watch<ProviderSubmitReport>().imageFile != null) {
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  context.read<ProviderSubmitReport>().imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Positioned(
                                right: 4,
                                bottom: 4,
                                child: Row(
                                  children: [
                                    FilledButton.tonalIcon(
                                      onPressed: () async {
                                        context.read<ProviderSubmitReport>().setImageFile(
                                          await takePhoto(context.read<ProviderSubmitReport>().picker),
                                        );
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
                                                  child: Image.file(context.read<ProviderSubmitReport>().imageFile!),
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
                              Icon(
                                Icons.camera_alt_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.outlineVariant,
                              ),
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
                  maxLengths: 30,
                  controller: context.read<ProviderSubmitReport>().titleCtrl,
                  icon: Icons.title_outlined,
                  labelText: "Title",
                  hintText: "e.g., Broken AC in Room 101",
                ),
                SizedBox(height: 16),
                LTextField(
                  maxLines: 3,
                  maxLengths: 175,
                  controller: context.read<ProviderSubmitReport>().descCtrl,
                  icon: Icons.description_outlined,
                  labelText: "Additional description\n(Optional, e.g., location details, etc.)",
                  hintText: 'e.g., The AC has been leaking water for two days.',
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return LDropdownMenu(
                            onSelected: (value) => setState(() {
                              context.read<ProviderSubmitReport>().unitCtrl.clear();
                              context.read<ProviderSubmitReport>().setSelectedUnit(-1);
                              context.read<ProviderSubmitReport>().setSelectedArea(value ?? 0);
                            }),
                            labelText: 'Area',
                            width: constraints.maxWidth,
                            leadingIcon: Icon(Icons.location_on_outlined),
                            initialSelection: context.read<ProviderSubmitReport>().selectedArea,
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
                              context.read<ProviderSubmitReport>().setSelectedUnit(value ?? 0);
                            }),
                            labelText: 'Unit',
                            width: constraints.maxWidth,
                            leadingIcon: Icon(Icons.apartment_outlined),
                            controller: context.read<ProviderSubmitReport>().unitCtrl,
                            initialSelection: context.read<ProviderSubmitReport>().selectedUnit,
                            dropdownMenuEntries: getBuildingEntries(context.read<ProviderSubmitReport>().selectedArea),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Consumer<ProviderSubmitReport>(
                  builder: (context, provider, child) {
                    return FilledButton(
                      onPressed: provider.isLoading
                          ? null
                          : () async {
                              final userId = context.read<ProviderLogin>().userData?['user_id'] ?? '';
                              final success = await provider.submitReport(userId);

                              if (context.mounted) {
                                if (success) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => LAlertDialog(
                                      icon: Icons.check_rounded,
                                      title: 'Success',
                                      content: Text('Your report has been submitted successfully.'),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => LAlertDialog(
                                      icon: Icons.close_rounded,
                                      title: 'Failed',
                                      content: Text(provider.errorMessage ?? 'Failed to submit report.'),
                                    ),
                                  );
                                }
                              }
                            },
                      child: provider.isLoading
                          ? SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text('Submit Report'),
                    );
                  },
                ),
              ],
            ),
            Consumer<ProviderReports>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (provider.userReports.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                        SizedBox(height: 16),
                        LText.bodyMedium(context, 'No reports yet'),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    final userId = context.read<ProviderLogin>().userData?['user_id'] ?? '';
                    await context.read<ProviderReports>().fetchUserReports(userId);
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16),
                    itemCount: provider.userReports.length,
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final report = provider.userReports[index];
                      final imageUrl = '${ApiService.baseUrl}/uploads/${report['image']}';
                      final createdAt = DateTime.parse(report['created_at']);
                      final date =
                          '${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}';
                      final time =
                          '${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}';

                      final status = report['status'] ?? 'pending';
                      IconData statusIcon;
                      String statusText;
                      switch (status) {
                        case 'active':
                          statusIcon = Icons.hourglass_empty;
                          statusText = 'Active';
                          break;
                        case 'completed':
                          statusIcon = Icons.done_all;
                          statusText = 'Completed';
                          break;
                        default:
                          statusIcon = Icons.warning_amber_rounded;
                          statusText = 'Pending';
                      }

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
                                          LText.bodyMedium(
                                            context,
                                            context.read<ProviderLogin>().userData?['name'] ?? '',
                                          ),
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
                                          Icon(statusIcon, size: 16),
                                          SizedBox(width: 4),
                                          Text(statusText, style: Theme.of(context).textTheme.bodyMedium),
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
