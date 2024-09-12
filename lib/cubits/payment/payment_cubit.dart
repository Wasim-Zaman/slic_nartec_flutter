import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/models/tax_exemption_reason_model.dart';
import 'package:slic/models/zatca_payment_mode_model.dart';
import 'package:slic/services/api_service.dart';

part 'payment_states.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  List<ZatcaPaymentModeModel> zatcaPaymentModes = [];
  List<TaxEcemptionReasonModel> taxReasions = [];

  String selectedPaymentMode = "";
  String selectedReason = "";

  getZATCAPaymentModes() async {
    emit(PaymentZATCAPaymentLoading());
    try {
      final response = await ApiService.slicGetData({
        "filter": {},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "ZATCAPAYMENTMODE",
        "M_LANG_CODE": "ENG"
      });

      response.forEach((element) {
        zatcaPaymentModes.add(ZatcaPaymentModeModel.fromJson(element));
      });
      emit(PaymentZATCAPaymentSuccess());
    } catch (error) {
      emit(PaymentZATCAPaymentError(errorMessage: error.toString()));
    }
  }

  getTaxExamptionReasons() async {
    emit(PaymentTaxExemptionReasonLoading());
    try {
      final response = await ApiService.slicGetData({
        "filter": {},
        "M_COMP_CODE": "SLIC",
        "M_USER_ID": "SYSADMIN",
        "APICODE": "TAXEXEMPTIONREASON",
        "M_LANG_CODE": "ENG"
      });

      response.forEach((element) {
        taxReasions.add(TaxEcemptionReasonModel.fromJson(element));
      });
      emit(PaymentTaxExemptionReasonSuccess());
    } catch (error) {
      emit(PaymentTaxExemptionReasonError(errorMessage: error.toString()));
    }
  }
}
