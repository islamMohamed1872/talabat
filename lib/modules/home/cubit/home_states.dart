abstract class HomeStates{}

class HomeInitialState extends HomeStates{}
class ChangeCurrentIndexState extends HomeStates{}
class ChangeSliderIndexState extends HomeStates{}

class GetCategoriesLoadingState extends HomeStates{}
class GetCategoriesSuccessState extends HomeStates{}
class GetCategoriesErrorState extends HomeStates{}

class GetAdsLoadingState extends HomeStates{}
class GetAdsSuccessState extends HomeStates{}
class GetAdsErrorState extends HomeStates{}