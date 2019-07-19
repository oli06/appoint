import 'package:appoint/models/user.dart';

class SignInViewModel {
  final bool isLoading;
  final User user;

  const SignInViewModel({
    this.isLoading,
    this.user,
  });
}
