import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/app_settings.dart';
import '../services/settings_service.dart';

class SettingsCubit extends Cubit<AppSettings> {
  final SettingsService service;
  Future<void> _saveQueue = Future<void>.value();

  SettingsCubit({required this.service, required AppSettings initial})
    : super(initial);

  /// 按顺序写入，避免快速输入时旧的设置覆盖新的设置。
  void _update(AppSettings next) {
    emit(next);
    _saveQueue = _saveQueue
        .then((_) => service.save(next))
        .catchError((Object _) {});
  }

  void setLanguage(String languageCode) {
    _update(state.copyWith(languageCode: languageCode));
  }

  void setThemeColor(int colorValue) {
    _update(state.copyWith(themeColorValue: colorValue));
  }

  void setGoalsEnabled(bool enabled) {
    _update(state.copyWith(goalsEnabled: enabled));
  }

  void setWeight(double weightKg) {
    _update(state.copyWith(weightKg: weightKg));
  }

  void setCarbsFactor(double value) {
    _update(state.copyWith(carbsFactor: value));
  }

  void setProteinFactor(double value) {
    _update(state.copyWith(proteinFactor: value));
  }

  void setFatFactor(double value) {
    _update(state.copyWith(fatFactor: value));
  }
}
