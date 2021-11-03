
abstract class RegisterStates {}

class RegisterInitState extends RegisterStates{}

class RegisterFirstStageCompletedState extends RegisterStates{}

class RegisterSecondStageCompletedState extends RegisterStates{}

class RegisterLoadingState extends RegisterStates{}

class RegisterSuccessState extends RegisterStates{}

class RegisterErrorState extends RegisterStates{
  final String errorMsg ;
  RegisterErrorState(this.errorMsg);
}

// drop down lists
class OnItemSelectedState extends RegisterStates {}

//password visibility
class RegisterSecureVisibilityChangeState extends RegisterStates {}
class RegisterPositionVisibilityChangeState extends RegisterStates {}
