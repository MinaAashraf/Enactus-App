
abstract class LoginStates {}

class LoginInitState extends LoginStates{}
class LoginLoadingState extends LoginStates{}
class LoginSuccessState extends LoginStates{}
class LoginErrorState extends LoginStates{
  final String errorMsg ;
  LoginErrorState(this.errorMsg);
}

// password visibility
class LoginSecureVisibilityState extends LoginStates{}
