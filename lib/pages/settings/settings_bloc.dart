import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_settings.dart';
import '../../services/settings_service.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService service;
  Future<void> _saveQueue = Future<void>.value();

  SettingsBloc({required this.service, required AppSettings initial})
    : super(SettingsState(initial)) {
    on<SettingsLanguageChanged>(
      (event, emit) => _update(
        emit,
        state.settings.copyWith(languageCode: event.languageCode),
      ),
    );
    on<SettingsThemeColorChanged>(
      (event, emit) => _update(
        emit,
        state.settings.copyWith(themeColorValue: event.colorValue),
      ),
    );
    on<SettingsGoalsCleared>(
      (event, emit) => _update(
        emit,
        state.settings.copyWith(
          weightKg: 0,
          carbsFactor: 0,
          proteinFactor: 0,
          fatFactor: 0,
        ),
      ),
    );
    on<SettingsWeightChanged>(
      (event, emit) =>
          _update(emit, state.settings.copyWith(weightKg: event.weightKg)),
    );
    on<SettingsCarbsFactorChanged>(
      (event, emit) =>
          _update(emit, state.settings.copyWith(carbsFactor: event.value)),
    );
    on<SettingsProteinFactorChanged>(
      (event, emit) =>
          _update(emit, state.settings.copyWith(proteinFactor: event.value)),
    );
    on<SettingsFatFactorChanged>(
      (event, emit) =>
          _update(emit, state.settings.copyWith(fatFactor: event.value)),
    );
  }

  /// 按顺序写入，避免快速输入时旧的设置覆盖新的设置。
  void _update(Emitter<SettingsState> emit, AppSettings next) {
    emit(SettingsState(next));
    _saveQueue = _saveQueue
        .then((_) => service.save(next))
        .catchError((Object _) {});
  }
}
