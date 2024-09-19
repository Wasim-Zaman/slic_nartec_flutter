import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/api_response.dart';
import 'package:slic/models/company.dart';
import 'package:slic/models/company_location.dart';
import 'package:slic/models/customer_model.dart';
import 'package:slic/models/location.dart';
import 'package:slic/services/api_service.dart';

part 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  List<Company> companies = [];
  List<Location> locations = [];

  List<CompanyModel> slicCompanies = [];
  List<LocationModel> slicLocations = [];

  List<CustomerModel> customers = [];

  String? company, location, fromLocation, toLocation, customerName;
  String? companyCode,
      locationCode,
      fromLocationCode,
      toLocationCode,
      customerCode;

  void getCompaniesLocations() async {
    emit(HomeGetCompanyLocationLoading());
    try {
      final response = await ApiService.getCompaniesLocations();
      if (response.success) {
        emit(HomeGetCompanyLocationSuccess(response));
      } else {
        emit(HomeGetCompanyLocationError(response.message));
      }
    } catch (error) {
      emit(HomeGetCompanyLocationError(error.toString()));
    }
  }

  getSlicCompanies() async {
    emit(HomeGetSlicCompaniesLoading());
    try {
      slicCompanies = await ApiService.getSlicCompanies();
      emit(HomeGetSlicCompaniesSuccess());
    } catch (error) {
      emit(HomeGetSlicCompaniesError(error.toString()));
    }
  }

  getSlicLocations() async {
    emit(HomeGetSlicLocationsLoading());
    try {
      slicLocations = await ApiService.getSlicLocations();
      emit(HomeGetSlicLocationsSuccess());
    } catch (error) {
      emit(HomeGetSlicLocationsError(error.toString()));
    }
  }

  getCustomers() async {
    emit(HomeGetCustomersSuccess());
    try {
      final response = await ApiService.getCustomers();
      if (response.success) {
        customers = response.data;
        emit(HomeGetCustomersSuccess());
      } else {
        emit(HomeGetCustomersError(response.message));
      }
    } catch (error) {
      emit(HomeGetCustomersError(error.toString()));
    }
  }
}
