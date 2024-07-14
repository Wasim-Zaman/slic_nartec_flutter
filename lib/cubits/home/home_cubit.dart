import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/api_response.dart';
import 'package:slic/models/company_location.dart';
import 'package:slic/services/api_service.dart';

part 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of<HomeCubit>(context);

  List<Company> companies = [];
  List<Location> locations = [];

  String? company, location;

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
      print(error);
      emit(HomeGetCompanyLocationError(error.toString()));
    }
  }
}
