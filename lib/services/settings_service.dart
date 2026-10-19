import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/app_settings.dart';

/// 使用应用文档目录下的 JSON 文件保存设置，避免引入额外依赖。
class SettingsService {
  final File _file;

  SettingsService(this._file);

  static Future<SettingsService> create() async {
    final docsDir = await getApplicationDocumentsDirectory();
    return SettingsService(File(p.join(docsDir.path, 'foody_settings.json')));
  }

  Future<AppSettings> load() async {
    try {
      if (await _file.exists()) {
        final content = await _file.readAsString();
        if (content.trim().isNotEmpty) {
          final json = jsonDecode(content) as Map<String, dynamic>;
          return AppSettings.fromJson(json);
        }
      }
    } catch (_) {
      // 读取失败时回退到默认设置
    }
    return const AppSettings();
  }

  Future<void> save(AppSettings settings) async {
    await _file.writeAsString(jsonEncode(settings.toJson()), flush: true);
  }
}
