abstract class CartStates{}

class CartInitialState extends CartStates{}

class LoadCartSuccessState extends CartStates{}
class LoadCartLoadingState extends CartStates{}

class ChangeSelectedItemState extends CartStates{}
class ChangeSelectedFilterState extends CartStates{}
class ChangeSandwichOptionState extends CartStates{}

class GetSandwichDetailsLoadingState extends CartStates {}
class GetSandwichDetailsSuccessState extends CartStates {}
class GetSandwichDetailsErrorState extends CartStates {}

class CheckOutLoadingState extends CartStates {}
class CheckOutSuccessState extends CartStates {}
class CheckOutErrorState extends CartStates {}
