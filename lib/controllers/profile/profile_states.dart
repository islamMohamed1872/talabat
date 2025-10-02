abstract class ProfileStates{}

class ProfileInitialState extends ProfileStates{}


class ProfileLanguageChangedState extends ProfileStates {}
class ProfileCountryChangedState extends ProfileStates {}

class GetWalletDetailsLoadingState extends ProfileStates {}
class GetWalletDetailsSuccessState extends ProfileStates {}
class GetWalletDetailsErrorState extends ProfileStates {}

class UpdateUserInfoLoadingState extends ProfileStates {}
class UpdateUserInfoSuccessState extends ProfileStates {}
class UpdateUserInfoErrorState extends ProfileStates {}

class GetOrdersLoadingState extends ProfileStates {}
class GetOrdersSuccessState extends ProfileStates {}
class GetOrdersErrorState extends ProfileStates {}

class ProfileImagePickedState extends ProfileStates {}
class ProfileImagePickCancelledState extends ProfileStates {}
class ProfileImagePickErrorState extends ProfileStates {}

class UploadProfileImageLoadingState extends ProfileStates {}
class UploadProfileImageSuccessState extends ProfileStates {}
class UploadProfileImageErrorState extends ProfileStates {}