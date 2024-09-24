part of 'home_cubit.dart';

abstract class HomeState {}

final class HomeInitial extends HomeState {}

// Loading

final class HomeGetCompanyLocationLoading extends HomeState {}

final class HomeGetSlicCompaniesLoading extends HomeState {}

final class HomeGetSlicLocationsLoading extends HomeState {}

final class HomeGetCustomers extends HomeState {}

final class HomeGetSalesmanLoading extends HomeState {}

final class HomeGetPaymentTermsLoading extends HomeState {}

// * Success

final class HomeGetCompanyLocationSuccess extends HomeState {
  final ApiResponse res;
  HomeGetCompanyLocationSuccess(this.res);
}

final class HomeGetSlicCompaniesSuccess extends HomeState {}

final class HomeGetSlicLocationsSuccess extends HomeState {}

final class HomeGetCustomersSuccess extends HomeState {}

final class HomeGetSalesmanSuccess extends HomeState {}

final class HomeGetPaymentTermsSuccess extends HomeState {}

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

final class HomeGetCustomersError extends HomeState {
  final String message;
  HomeGetCustomersError(this.message);
}

final class HomeGetSalesmanError extends HomeState {
  final String message;
  HomeGetSalesmanError(this.message);
}

final class HomeGetPaymentTermsError extends HomeState {
  final String message;
  HomeGetPaymentTermsError(this.message);
}
