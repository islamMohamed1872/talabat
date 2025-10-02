abstract class RegisterStates{}

class RegisterInitialState extends RegisterStates{}
class TogglePasswordState extends RegisterStates{}

class CreateAccountLoadingState extends RegisterStates{}
class CreateAccountSuccessState extends RegisterStates{}
class CreateAccountErrorState extends RegisterStates{}