class UpdateSettingForKeyAction {
  final String key;
  final dynamic value;

  UpdateSettingForKeyAction(this.key, this.value);
}

class LoadSharedPreferencesAction {}

class LoadedSharedPreferencesAction {
  final Map<String, dynamic> settings;

  LoadedSharedPreferencesAction(this.settings);
}
