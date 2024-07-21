part of 'home_cubit.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

// Loading

final class HomeGetCompanyLocationLoading extends HomeState {}

final class HomeGetSlicCompaniesLoading extends HomeState {}

final class HomeGetSlicLocationsLoading extends HomeState {}

// * Success

final class HomeGetCompanyLocationSuccess extends HomeState {
  final ApiResponse res;
  HomeGetCompanyLocationSuccess(this.res);
}

final class HomeGetSlicCompaniesSuccess extends HomeState {}

final class HomeGetSlicLocationsSuccess extends HomeState {}

// ! Error

final class HomeGetCompanyLocationError extends HomeState {
  final String message;
  HomeGetCompanyLocationError(this.message);
}

final class HomeGetSlicCompaniesError extends HomeState {
  final String message;
  HomeGetSlicCompaniesError(this.message);
}

final class HomeGetSlicLocationsError extends HomeState {
  final String message;
  HomeGetSlicLocationsError(this.message);
}
