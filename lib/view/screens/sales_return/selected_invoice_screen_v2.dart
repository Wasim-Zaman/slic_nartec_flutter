import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/sales_return/sales_return_cubit.dart';
import 'package:slic/models/invoice_details_slic_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SelectedInvoiceScreen extends StatelessWidget {
  final InvoiceDetailsSlicModel model;
  const SelectedInvoiceScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location: ${HomeCubit.get(context).locationCode}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text('Transaction Code'),
            // const SizedBox(height: 8),
            // TextFieldWidget(
            //   readOnly: true,
            //   initialValue: model.transactionCode,
            // ),
            // const SizedBox(height: 16),
            // const Text('SO Date'),
            // const SizedBox(height: 8),
            // TextFieldWidget(
            //   readOnly: true,
            //   initialValue: model.transactionDate,
            // ),
            // const SizedBox(height: 16),
            // const Text('Customer'),
            // const SizedBox(height: 8),
            // TextFieldWidget(
            //   readOnly: true,
            //   initialValue: model.customerCode,
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text('Item Code'),
            //           const SizedBox(height: 8),
            //           TextFieldWidget(
            //             readOnly: true,
            //             initialValue: model.itemSKU,
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text('Size'),
            //           const SizedBox(height: 8),
            //           TextFieldWidget(
            //             readOnly: true,
            //             initialValue: model.itemSize,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // const Text('Description'),
            // const SizedBox(height: 8),
            // TextFieldWidget(
            //   readOnly: true,
            //   initialValue: model.itemSKU,
            // ),
            // const SizedBox(height: 16),
            // Row(
            //   children: [
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text('Invoice Quantity'),
            //           const SizedBox(height: 8),
            //           TextFieldWidget(
            //             readOnly: true,
            //             initialValue: model.itemQry.toString(),
            //           ),
            //         ],
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           const Text('Return Quantity'),
            //           const SizedBox(height: 8),
            //           TextFieldWidget(
            //             filledColor: ColorPallete.accent.withOpacity(0.6),
            //             initialValue: model.itemQry.toString(),
            //             onChanged: (value) {
            //               // update return quantity
            //               SalesReturnCubit.get(context).returnQty =
            //                   num.tryParse(value);
            //             },
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            // const Spacer(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Expanded(
            //       child: AppButton(
            //         text: "Back",
            //         backgroundColor: Colors.red,
            //         onPressed: () {
            //           Navigation.pop(context);
            //         },
            //       ),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //         child: BlocConsumer<SalesReturnCubit, SalesReturnState>(
            //       listener: (context, state) {
            //         if (state is SalesReturnUpdateTempError) {
            //           ScaffoldMessenger.of(context).showSnackBar(
            //             SnackBar(content: Text(state.errorMessage)),
            //           );
            //         } else if (state is SalesReturnUpdateTempSuccess) {
            //           showTopSnackBar(
            //             Overlay.of(context),
            //             CustomSnackBar.success(message: state.successMessage),
            //           );
            //           Navigation.pop(context);
            //         }
            //       },
            //       builder: (context, state) {
            //         if (state is SalesReturnUpdateTempLoading) {
            //           return const LoadingWidget();
            //         }
            //         return AppButton(
            //           text: "Save",
            //           onPressed: () {
            //             if (SalesReturnCubit.get(context).returnQty == null) {
            //               SalesReturnCubit.get(context).returnQty =
            //                   model.itemQry;
            //             }
            //             SalesReturnCubit.get(context)
            //                 .updateInvoiceTemp(model.itemSysID, model.itemSKU);
            //           },
            //         );
            //       },
            //     )),
            //   ],
            // ),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Item Code'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: model.iNVTOSRITEMDETAILS?.iNVIITEMCODE,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Size'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: model.iNVTOSRITEMDETAILS?.iNVIGRADECODE1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Description'),
            const SizedBox(height: 8),
            TextFieldWidget(
              readOnly: true,
              initialValue: model.iNVTOSRITEMDETAILS?.iNVIITEMDESC,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Invoice Quantity'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue:
                            model.iNVTOSRITEMDETAILS?.iNVIQTY.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Return Quantity'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        filledColor: ColorPallete.accent.withOpacity(0.6),
                        initialValue:
                            model.iNVTOSRITEMDETAILS?.iNVIQTY.toString(),
                        onChanged: (value) {
                          // update return quantity
                          SalesReturnCubit.get(context).returnQty =
                              num.tryParse(value);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(
                    text: "Back",
                    backgroundColor: Colors.red,
                    onPressed: () {
                      Navigation.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                    child: BlocConsumer<SalesReturnCubit, SalesReturnState>(
                  listener: (context, state) {
                    if (state is SalesReturnUpdateTempError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)),
                      );
                    } else if (state is SalesReturnUpdateTempSuccess) {
                      showTopSnackBar(
                        Overlay.of(context),
                        CustomSnackBar.success(message: state.successMessage),
                      );
                      Navigation.pop(context);
                    }
                  },
                  builder: (context, state) {
                    if (state is SalesReturnUpdateTempLoading) {
                      return const LoadingWidget();
                    }
                    return AppButton(
                      text: "Save",
                      onPressed: () {
                        if (SalesReturnCubit.get(context).returnQty == null) {
                          SalesReturnCubit.get(context).returnQty =
                              model.iNVTOSRITEMDETAILS?.iNVIQTY;
                        }
                        SalesReturnCubit.get(context).updateInvoiceTemp(
                            model.iNVTOSRITEMDETAILS?.iNVISYSID.toString(),
                            model.iNVTOSRITEMDETAILS?.iNVIITEMCODE);
                      },
                    );
                  },
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
