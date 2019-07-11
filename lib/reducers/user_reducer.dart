import 'package:appoint/actions/user_action.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:redux/redux.dart';

final userReducer = combineReducers<UserViewModel>([
  TypedReducer<UserViewModel, LoadedUserAction>(_setLoadedUser),
  TypedReducer<UserViewModel, UpdateUserLoadingAction>(_updateIsLoading),
  TypedReducer<UserViewModel, LoadedUserLocationAction>(_loadedUserLocation),
]);

UserViewModel _setLoadedUser(UserViewModel vm, LoadedUserAction action) {
  return UserViewModel(
    user: action.user,
    isLoading: vm.isLoading,
    currentLocation: vm.currentLocation,
  );
}

UserViewModel _updateIsLoading(
    UserViewModel vm, UpdateUserLoadingAction action) {
  return UserViewModel(
    user: vm.user,
    isLoading: action.isLoading,
    currentLocation: vm.currentLocation,
  );
}

UserViewModel _loadedUserLocation(
    UserViewModel vm, LoadedUserLocationAction action) {
  return UserViewModel(
    user: vm.user,
    isLoading: vm.isLoading,
    currentLocation: action.location,
  );
}
