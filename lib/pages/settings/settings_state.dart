import 'package:equatable/equatable.dart';

import '../../models/app_settings.dart';

class SettingsState extends Equatable {
  final AppSettings settings;

  const SettingsState(this.settings);

  @override
  List<Object?> get props => [settings];
}
