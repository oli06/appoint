
class UpdateSettingForKeyAction {
  final dynamic key;
  final dynamic value;

  UpdateSettingForKeyAction(this.key, this.value);
}

class LoadSharedPreferencesAction {}

class LoadedSharedPreferencesAction {
  final Map<dynamic, dynamic> settings;

  LoadedSharedPreferencesAction(this.settings);
}