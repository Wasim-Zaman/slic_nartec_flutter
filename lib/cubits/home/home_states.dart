part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

// Loading

class HomeGetCompanyLocationLoading extends HomeState {}

// * Success

class HomeGetCompanyLocationSuccess extends HomeState {
  final ApiResponse res;
  HomeGetCompanyLocationSuccess(this.res);
}

// ! Error

class HomeGetCompanyLocationError extends HomeState {
  final String message;
  HomeGetCompanyLocationError(this.message);
}
