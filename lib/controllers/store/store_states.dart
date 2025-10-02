abstract class StoreStates{}

class StoreInitialState extends StoreStates{}

class GetAllRestaurantsLoadingState extends StoreStates {}
class GetAllRestaurantsSuccessState extends StoreStates {}
class GetAllRestaurantsErrorState extends StoreStates {}

class GetRestaurantDetailsLoadingState extends StoreStates {}
class GetRestaurantDetailsSuccessState extends StoreStates {}
class GetRestaurantDetailsErrorState extends StoreStates {}

class GetSandwichDetailsLoadingState extends StoreStates {}
class GetSandwichDetailsSuccessState extends StoreStates {}
class GetSandwichDetailsErrorState extends StoreStates {}

class StoreLoadingState extends StoreStates {}

class StoreSuccessState extends StoreStates {}

class StoreErrorState extends StoreStates {
  final String error;
  StoreErrorState(this.error);
}

class StoreSearchState extends StoreStates {}
class StoreBannerOpacityChanged extends StoreStates {}

class StoreSortState extends StoreStates {}

class StoreCategoryFilterState extends StoreStates {}
class ChangeSelectedFilterState extends StoreStates {}
class ChangeSelectedSandwichOptionState extends StoreStates {}

class ChangeRestaurantFilterState extends StoreStates {}
class ChangeFoodFilterState extends StoreStates {}
class ChangeSandwichOptionState extends StoreStates {}
class ChangeIngredientsState extends StoreStates {}
class ChangeItemCountState extends StoreStates {}