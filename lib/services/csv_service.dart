import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CsvService {
  static Future<String?> exporToCsv({
    required List<Map<String, dynamic>> pendingReports,
    required List<Map<String, dynamic>> activeReports,
    required List<Map<String, dynamic>> completedReports,
    required List<Map<String, dynamic>> rejectedReports,
  }) async {
    try {
      final allReports = [...pendingReports, ...activeReports, ...completedReports, ...rejectedReports];

      if (allReports.isEmpty) {
        return null;
      }

      final StringBuffer buffer = StringBuffer();
      buffer.writeln('title,description,area,unit,status,userId,userName,createdAt');

      for (final report in allReports) {
        final title = filterText(report['title'] ?? '');
        final description = filterText(report['description'] ?? '');
        final area = filterText(report['area'] ?? '');
        final unit = filterText(report['unit'] ?? '');
        final status = report['status'] ?? '';
        final userId = report['user_id'] ?? '';
        final userName = filterText(report['user_name'] ?? '');
        final createdAt = report['created_at'] ?? '';

        buffer.writeln('$title,$description,$area,$unit,$status,$userId,$userName,$createdAt');
      }

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage');
      }

      final downloadsPath = directory.path.replaceAll(RegExp(r'/Android/data/[^/]+/files'), '/Download');
      final downloadsDir = Directory(downloadsPath);
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '$downloadsPath/laporin_reports_$timestamp.csv';
      final file = File(filePath);
      await file.writeAsString(buffer.toString());

      return filePath;
    } catch (e) {
      print('Error exporting CSV: $e');
      return null;
    }
  }

  static String filterText(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '').replaceAll('\n', ' ')}"';
    }
    return value;
  }
}
