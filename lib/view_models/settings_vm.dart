class SettingsViewModel {
  final Map<String, dynamic> settings;

  const SettingsViewModel({
    this.settings,
  });

  @override
  int get hashCode => settings.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsViewModel &&
          runtimeType == other.runtimeType &&
          settings == other.settings;
}
