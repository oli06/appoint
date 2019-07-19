/* import 'package:appoint/actions/signin_action.dart';
import 'package:redux/redux.dart';
import 'package:appoint/view_models/signin_vm.dart';

final signInReducer = combineReducers<SignInViewModel>([
  TypedReducer<SignInViewModel, UpdateSignInUserAction>(_updateUser),
  TypedReducer<SignInViewModel, UpdateSignInIsLoadingAction>(_updateIsLoading),

]);

SignInViewModel _updateUser(
    SignInViewModel vm, UpdateSignInUserAction action) {
  return SignInViewModel(
    isLoading: vm.isLoading,
    user: action.user,
  );
}

SignInViewModel _updateIsLoading(
    SignInViewModel vm, UpdateSignInIsLoadingAction action) {
  return SignInViewModel(
    isLoading: action.isLoading,
    user: vm.user,
  );
} */