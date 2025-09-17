abstract class StoreStates{}

class StoreInitialState extends StoreStates{}

class StoreLoadingState extends StoreStates {}

class StoreSuccessState extends StoreStates {}

class StoreErrorState extends StoreStates {
  final String error;
  StoreErrorState(this.error);
}

class StoreSearchState extends StoreStates {}

class StoreSortState extends StoreStates {}

class StoreCategoryFilterState extends StoreStates {}
class ChangeSelectedFilterState extends StoreStates {}
class ChangeSelectedSandwichOptionState extends StoreStates {}
