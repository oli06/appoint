import 'package:appoint/models/user.dart';

class SignInViewModel {
  final bool isLoading;
  final User user;

  const SignInViewModel({
    this.isLoading,
    this.user,
  });

  @override
  int get hashCode => user.hashCode ^ isLoading.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SignInViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          user == other.user;
}
