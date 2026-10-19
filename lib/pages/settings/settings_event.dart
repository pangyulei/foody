import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsLanguageChanged extends SettingsEvent {
  final String languageCode;

  const SettingsLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class SettingsThemeColorChanged extends SettingsEvent {
  final int colorValue;

  const SettingsThemeColorChanged(this.colorValue);

  @override
  List<Object?> get props => [colorValue];
}

class SettingsGoalsEnabledChanged extends SettingsEvent {
  final bool enabled;

  const SettingsGoalsEnabledChanged(this.enabled);

  @override
  List<Object?> get props => [enabled];
}

class SettingsWeightChanged extends SettingsEvent {
  final double weightKg;

  const SettingsWeightChanged(this.weightKg);

  @override
  List<Object?> get props => [weightKg];
}

class SettingsCarbsFactorChanged extends SettingsEvent {
  final double value;

  const SettingsCarbsFactorChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class SettingsProteinFactorChanged extends SettingsEvent {
  final double value;

  const SettingsProteinFactorChanged(this.value);

  @override
  List<Object?> get props => [value];
}

class SettingsFatFactorChanged extends SettingsEvent {
  final double value;

  const SettingsFatFactorChanged(this.value);

  @override
  List<Object?> get props => [value];
}
