import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/payment/payment_cubit.dart';
import 'package:slic/cubits/sales_return/sales_return_cubit.dart';
import 'package:slic/cubits/trx/trx_cubit.dart';
import 'package:slic/models/invoice_details_slic_model.dart';
import 'package:slic/models/trx_codes_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/sales_return/selected_invoice_screen_v2.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SalesReturnInvoiceScreen extends StatefulWidget {
  const SalesReturnInvoiceScreen({super.key});

  @override
  State<SalesReturnInvoiceScreen> createState() =>
      _SalesReturnInvoiceScreenState();
}

class _SalesReturnInvoiceScreenState extends State<SalesReturnInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  PaymentCubit paymentCubit = PaymentCubit();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await TrxCubit.get(context)
        .getTrxByLocationCode(HomeCubit.get(context).locationCode);
    await SalesReturnCubit.get(context).getTransactionCodes();

    // Payment
    await paymentCubit.getZATCAPaymentModes();
    await paymentCubit.getTaxExamptionReasons();

    setState(() {
      SalesReturnCubit.get(context).invoiceDetails = null;
    });
  }

  void _onComplete() {
    FocusManager.instance.primaryFocus?.unfocus();
    SalesReturnCubit.get(context).getSlicInvoiceDetails();
  }

  Widget _buildDropdown({
    required String title,
    required List<String> options,
    required String? defaultValue,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 4),
        CustomDropdownButton(
          items: options,
          defaultValue: defaultValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Return Invoice"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<PaymentCubit, PaymentState>(
                bloc: paymentCubit,
                builder: (context, state) {
                  return _buildDropdown(
                    title: "Select ZATCA Payment Mode",
                    options: paymentCubit.zatcaPaymentModes
                        .where((element) =>
                            element.zATCAPAYMENTMODE?.vSSVNAME != null ||
                            element.zATCAPAYMENTMODE?.vSSVCODE != null)
                        .map((e) =>
                            "${e.zATCAPAYMENTMODE?.vSSVNAME} -- ${e.zATCAPAYMENTMODE?.vSSVCODE}")
                        .toSet()
                        .toList(),
                    defaultValue: null,
                    onChanged: (value) {
                      setState(() {
                        paymentCubit.selectedPaymentMode =
                            value!.split(" -- ")[1];
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<PaymentCubit, PaymentState>(
                bloc: paymentCubit,
                builder: (context, state) {
                  return _buildDropdown(
                    title: "Select Tax Exemption Reason",
                    options: paymentCubit.taxReasions
                        .where((element) =>
                            element.tAXEXEMPTIONREASON?.vSSVNAME != null ||
                            element.tAXEXEMPTIONREASON?.vSSVCODE != null)
                        .map((e) =>
                            "(${e.tAXEXEMPTIONREASON?.vSSVCODE}) -- ${e.tAXEXEMPTIONREASON?.vSSVNAME}")
                        .toSet()
                        .toList(),
                    defaultValue: null,
                    onChanged: (value) {
                      setState(() {
                        paymentCubit.selectedReason = value!.split(" -- ")[1];
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<TrxCubit, TrxState>(
                builder: (context, state) {
                  return _buildDropdown(
                    title: "Select Transaction Code",
                    options: [
                      ...TrxCubit.get(context).filteredTransactions,
                      ...[
                        TrxCodesModel(tXNCODE: "DMIN"),
                        TrxCodesModel(tXNCODE: "LRIN"),
                        TrxCodesModel(tXNCODE: "LYIN"),
                        TrxCodesModel(tXNCODE: "LJIN"),
                      ]
                    ]
                        .where((element) =>
                            element.tXNCODE != null || element.tXNNAME != null)
                        .map((e) => e.tXNCODE.toString())
                        .toSet()
                        .toList(),
                    defaultValue: SalesReturnCubit.get(context).transactionCode,
                    onChanged: (value) {
                      setState(() {
                        SalesReturnCubit.get(context).transactionCode = value;
                        // stockTransferCubit.transactionCode = stockTransferCubit
                        //         .transactionCodes
                        //         .firstWhere((element) =>
                        //             element.listOfTransactionCod!.tXNNAME ==
                        //             value)
                        //         .listOfTransactionCod!
                        //         .tXNCODE ??
                        //     '';
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocConsumer<SalesReturnCubit, SalesReturnState>(
                buildWhen: (previous, current) =>
                    current is SalesReturnPOSInvoiceSuccess ||
                    current is SalesReturnPOSInvoiceLoading ||
                    current is SalesReturnPOSInvoiceError ||
                    current is SalesReturnChangedItemSysId,
                listener: (context, state) {
                  if (state is SalesReturnPOSInvoiceError) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(message: state.errorMessage),
                    );
                  } else if (state is SalesReturnPOSInvoiceSuccess) {
                    // SalesReturnCubit.get(context).getItemSysIdsByHeadSysId(
                    //     SalesReturnCubit.get(context)
                    //         .invoiceDetails
                    //         ?.invoiceHeader
                    //         ?.headSYSID);
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Enter Invoice Number"),
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldWidget(
                              onChanged: (value) {
                                SalesReturnCubit.get(context).invoiceNumber =
                                    value;
                              },
                              onEditingComplete: _onComplete,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _onComplete,
                            icon: const Icon(Icons.search),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state is SalesReturnPOSInvoiceLoading)
                        const LoadingWidget(),
                      if (state is SalesReturnPOSInvoiceSuccess ||
                          state is SalesReturnChangedItemSysId)
                        _buildInvoiceTable(
                          SalesReturnCubit.get(context).slicInvoices,
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocConsumer<SalesReturnCubit, SalesReturnState>(
                listener: (context, state) {
                  if (state is SalesReturnSaveInvoiceSuccess) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            state.successMessage,
                            textAlign: TextAlign.center,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(state.successMessage),
                              ...[
                                const SizedBox(height: 16),
                                if (state.salesReturnDocNo != null)
                                  Text(
                                      "Sales Retrurn Doc No: ${state.salesReturnDocNo}"), // Display GRN System ID if not null
                                if (state.salesReturnSysId != null)
                                  Text(
                                      "Sales Return Sys Id: ${state.salesReturnSysId}"), // Display GRN Document No if not null
                              ],
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigation.pop(context);
                                Navigation.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                    Navigation.pop(context);
                  } else if (state is SalesReturnSaveInvoiceError) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(message: state.errorMessage),
                    );
                  }
                },
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      state is SalesReturnSaveInvoiceLoading
                          ? const LoadingWidget()
                          : AppButton(
                              text: "Save & Submit",
                              onPressed: () {
                                // unfocus keyboard
                                FocusManager.instance.primaryFocus?.unfocus();
                                SalesReturnCubit.get(context).saveSalesInvoice(
                                  paymentCubit.selectedPaymentMode,
                                  paymentCubit.selectedReason,
                                );
                              },
                            ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildInvoiceTable(List<InvoiceDetails> data) {
  //   final dataSource = InvoiceDataSource(data, context);

  //   return Container(
  //     padding: const EdgeInsets.all(8.0),
  //     color: Colors.white,
  //     child: PaginatedDataTable(
  //       columns: const [
  //         DataColumn(label: Text('Item SKU')),
  //         DataColumn(label: Text('Item Quantity')),
  //         DataColumn(label: Text('Return Quantity')),
  //         DataColumn(label: Text('Invoice No')),
  //         DataColumn(label: Text('Customer Code')),
  //         DataColumn(label: Text('Delivery Location Code')),
  //         DataColumn(label: Text('Item Rate')),
  //         DataColumn(label: Text('Item Price')),
  //         DataColumn(label: Text('Item Size')),
  //         DataColumn(label: Text('Item Sys ID')),
  //         DataColumn(label: Text('Item Unit')),
  //         DataColumn(label: Text('Rec Num')),
  //         DataColumn(label: Text('Remarks')),
  //         DataColumn(label: Text('S No')),
  //         DataColumn(label: Text('Sales Location Code')),
  //         DataColumn(label: Text('Tbl Sys No ID')),
  //         DataColumn(label: Text('Transaction Code')),
  //         DataColumn(label: Text('Transaction Type')),
  //         DataColumn(label: Text('User ID')),
  //         DataColumn(label: Text('Head Sys ID')),
  //         DataColumn(label: Text('Transaction Date')),
  //       ],
  //       source: dataSource,
  //       columnSpacing: 20,
  //       horizontalMargin: 10,
  //       rowsPerPage: 5,
  //       showCheckboxColumn: true, // Show checkboxes for selection
  //     ),
  //   );
  // }

  Widget _buildInvoiceTable(List<InvoiceDetailsSlicModel> data) {
    final dataSource = InvoiceDataSource(data, context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('iNVHNO')),
          DataColumn(label: Text('iNVIQTY')),
          DataColumn(label: Text('iNVISYSID')),
          DataColumn(label: Text('iNVIINVHSYSID')),
          DataColumn(label: Text('iNVIGRADECODE1')),
          DataColumn(label: Text('iNVIGRADECODE2')),
          DataColumn(label: Text('iNVIITEMCODE')),
          DataColumn(label: Text('iNVIITEMDESC')),
          DataColumn(label: Text('iNVIUOMCODE')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 5,
        showCheckboxColumn: true, // Show checkboxes for selection
      ),
    );
  }
}

class InvoiceDataSource extends DataTableSource {
  final List<InvoiceDetailsSlicModel> _data;
  final BuildContext context;
  final Set<int> _selectedRows = {};

  InvoiceDataSource(this._data, this.context);

  @override
  DataRow getRow(int index) {
    final InvoiceDetailsSlicModel data = _data[index];
    final bool isSelected = _selectedRows.contains(index);

    return DataRow.byIndex(
      index: index,
      selected: isSelected,
      onSelectChanged: (bool? selected) {
        _toggleSelection(index, data, selected);
      },
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          // if (data.changed == true) {
          //   return Colors.lightBlue;
          // }
          return null;
        },
      ),
      cells: <DataCell>[
        ...[
          '${data.iNVTOSRITEMDETAILS?.iNVHNO ?? ""}',
          '${data.iNVTOSRITEMDETAILS?.iNVIQTY ?? ""}',
          '${data.iNVTOSRITEMDETAILS?.iNVISYSID ?? ""}',
          '${data.iNVTOSRITEMDETAILS?.iNVIINVHSYSID ?? ""}',
          (data.iNVTOSRITEMDETAILS?.iNVIGRADECODE1 ?? ""),
          (data.iNVTOSRITEMDETAILS?.iNVIGRADECODE2 ?? ""),
          (data.iNVTOSRITEMDETAILS?.iNVIITEMCODE ?? ""),
          (data.iNVTOSRITEMDETAILS?.iNVIITEMDESC ?? ""),
          (data.iNVTOSRITEMDETAILS?.iNVIUOMCODE ?? ""),
        ].map((value) {
          return DataCell(
            GestureDetector(
              onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
              child: Text(value),
            ),
          );
        }),
      ],
    );
  }

  // Method to toggle row selection or deselection
  void _toggleSelection(
      int index, InvoiceDetailsSlicModel invoice, bool? selected) {
    if (selected == true) {
      _selectedRows.add(index);
      SalesReturnCubit.get(context).addSlicSelectedInvoice(invoice);
    } else {
      _selectedRows.remove(index);
      SalesReturnCubit.get(context).removeSlicSelectedInvoice(invoice);
    }

    notifyListeners();
  }

  void _navigateToSelectedInvoiceScreen(InvoiceDetailsSlicModel invoice) {
    Navigation.push(context, SelectedInvoiceScreen(model: invoice));
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount =>
      _selectedRows.length; // Reflect number of selected rows
}


// class InvoiceDataSource extends DataTableSource {
//   final List<InvoiceDetails> _data;
//   final BuildContext context;
//   final Set<int> _selectedRows = {};

//   InvoiceDataSource(this._data, this.context);

//   @override
//   DataRow getRow(int index) {
//     final InvoiceDetails data = _data[index];
//     final bool isSelected = _selectedRows.contains(index);

//     return DataRow.byIndex(
//       index: index,
//       selected: isSelected, // Reflect if the row is selected
//       onSelectChanged: (bool? selected) {
//         _toggleSelection(index, data, selected);
//       },
//       color: WidgetStateProperty.resolveWith<Color?>(
//         (Set<WidgetState> states) {
//           if (data.changed == true) {
//             return Colors.lightBlue;
//           }
//           return null;
//         },
//       ),
//       cells: <DataCell>[
//         ...[
//           '${data.itemSKU}',
//           '${data.itemQry}',
//           '${data.returnQty}',
//           '${data.invoiceNo}',
//           '${data.customerCode}',
//           '${data.deliveryLocationCode}',
//           '${data.iTEMRATE}',
//           '${data.itemPrice}',
//           '${data.itemSize}',
//           '${data.itemSysID}',
//           '${data.itemUnit}',
//           '${data.recNum}',
//           '${data.remarks}',
//           '${data.sNo}',
//           '${data.salesLocationCode}',
//           '${data.tblSysNoID}',
//           '${data.transactionCode}',
//           '${data.transactionType}',
//           '${data.userID}',
//           '${data.headSYSID}',
//           data.transactionDate != null
//               ? DateFormat.yMEd()
//                   .format(DateTime.parse(data.transactionDate.toString()))
//               : '',
//         ].map((value) {
//           return DataCell(
//             GestureDetector(
//               onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
//               child: Text(value),
//             ),
//           );
//         }),
//       ],
//     );
//   }

//   // Method to toggle row selection or deselection
//   void _toggleSelection(int index, InvoiceDetails invoice, bool? selected) {
//     if (selected == true) {
//       _selectedRows.add(index);
//       SalesReturnCubit.get(context).addSelectedInvoice(invoice);
//     } else {
//       _selectedRows.remove(index);
//       SalesReturnCubit.get(context).removeSelectedInvoice(invoice);
//     }

//     notifyListeners();
//   }

//   void _navigateToSelectedInvoiceScreen(InvoiceDetails invoice) {
//     Navigation.push(context, SelectedInvoiceScreen(model: invoice));
//   }

//   @override
//   int get rowCount => _data.length;

//   @override
//   bool get isRowCountApproximate => false;

//   @override
//   int get selectedRowCount =>
//       _selectedRows.length; // Reflect number of selected rows
// }

