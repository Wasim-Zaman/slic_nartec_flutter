import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/trx_codes_model.dart';
import 'package:slic/services/api_service.dart';

part 'trx_states.dart';

class TrxCubit extends Cubit<TrxState> {
  TrxCubit() : super(TrxInitial());

  static TrxCubit get(context) => BlocProvider.of(context);

  List<TrxCodesModel> filteredTransactions = [];
  // Add your methods here

  getTrxByLocationCode(locationCode) async {
    emit(TrxByLocationCodeLoaded());
    try {
      final response = await ApiService.getTrx(locationCode);
      if (response.success) {
        filteredTransactions = response.data;
        emit(TrxByLocationCodeLoaded());
      } else {
        emit(TrxByLocationCodeError(errorMessage: response.message));
      }
    } catch (error) {
      emit(TrxByLocationCodeError(errorMessage: error.toString()));
    }
  }
}
