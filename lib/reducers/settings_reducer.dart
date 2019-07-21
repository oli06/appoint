import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:redux/redux.dart';

final settingsReducer = combineReducers<SettingsViewModel>([
  TypedReducer<SettingsViewModel, LoadedSharedPreferencesAction>(_loadedSharedPreferences),
  TypedReducer<SettingsViewModel, UpdateSettingForKeyAction>(_updateIsLoading),
]);

SettingsViewModel _updateIsLoading(
    SettingsViewModel vm, UpdateSettingForKeyAction action) {
  vm.settings[action.key] = action.value;
  return SettingsViewModel(
    settings: vm.settings,
  );
}

SettingsViewModel _loadedSharedPreferences(
    SettingsViewModel vm, LoadedSharedPreferencesAction action) {
  return SettingsViewModel(
    settings: action.settings,
  );
}

