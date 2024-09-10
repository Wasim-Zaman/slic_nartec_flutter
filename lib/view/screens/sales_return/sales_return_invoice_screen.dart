import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/sales_return/sales_return_cubit.dart';
import 'package:slic/cubits/trx/trx_cubit.dart';
import 'package:slic/models/pos_invoice_model.dart';
import 'package:slic/models/trx_codes_model.dart';
import 'package:slic/view/screens/sales_return/selected_invoice_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    TrxCubit.get(context)
        .getTrxByLocationCode(HomeCubit.get(context).locationCode);
    final cubit = SalesReturnCubit.get(context);
    await cubit.getTransactionCodes();
    setState(() {});
  }

  void _handleSubmit() {
    FocusManager.instance.primaryFocus?.unfocus();
    SalesReturnCubit.get(context).getPOSInvoice();
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
    final stockTransferCubit = SalesReturnCubit.get(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Return"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        .where((element) => element.tXNCODE != null)
                        .map((e) => e.tXNCODE.toString())
                        .toSet()
                        .toList(),
                    defaultValue: stockTransferCubit.transactionCode,
                    onChanged: (value) {
                      setState(() {
                        stockTransferCubit.transactionName = value!;
                        stockTransferCubit.transactionCode = stockTransferCubit
                                .transactionCodes
                                .firstWhere((element) =>
                                    element.listOfTransactionCod!.tXNNAME ==
                                    value)
                                .listOfTransactionCod!
                                .tXNCODE ??
                            '';
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocConsumer<SalesReturnCubit, SalesReturnState>(
                listener: (context, state) {
                  if (state is SalesReturnPOSInvoiceError) {
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.error(message: state.errorMessage),
                    );
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
                              onEditingComplete: _handleSubmit,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: _handleSubmit,
                            icon: const Icon(Icons.search),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state is SalesReturnPOSInvoiceLoading)
                        const LoadingWidget(),
                      if (state is SalesReturnPOSInvoiceSuccess)
                        _buildInvoiceTable(
                          SalesReturnCubit.get(context).invoices,
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(
                    text: "Save & Submit",
                    onPressed: _handleSubmit,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInvoiceTable(List<POSInvoiceModel> data) {
    final dataSource = InvoiceDataSource(data, context);

    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('Invoice No')),
          DataColumn(label: Text('Transaction Code')),
          DataColumn(label: Text('Customer Code')),
          DataColumn(label: Text('Item SKU')),
          DataColumn(label: Text('Item Price')),
          DataColumn(label: Text('Item Quantity')),
          DataColumn(label: Text('Transaction Date')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 10,
        showCheckboxColumn: false,
      ),
    );
  }
}

class InvoiceDataSource extends DataTableSource {
  final List<POSInvoiceModel> _data;
  final BuildContext context;

  InvoiceDataSource(this._data, this.context);

  @override
  DataRow getRow(int index) {
    final POSInvoiceModel data = _data[index];
    return DataRow.byIndex(
      index: index,
      color: WidgetStateProperty.resolveWith<Color>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return ColorPallete.primary.withOpacity(0.3);
          }
          if (index.isEven) {
            return ColorPallete.background;
          }
          return Colors.white;
        },
      ),
      cells: <DataCell>[
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.invoiceNo ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.transactionCode ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.customerCode ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.itemSKU ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.itemPrice?.toString() ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: Text(data.itemQry?.toString() ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => _navigateToSelectedInvoiceScreen(data),
            child: DateTime.tryParse(data.transactionDate.toString()) == null
                ? null
                : Text(DateFormat.yMEd()
                    .format(DateTime.parse(data.transactionDate.toString()))),
          ),
        ),
      ],
    );
  }

  void _navigateToSelectedInvoiceScreen(POSInvoiceModel invoice) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectedInvoiceScreen(model: invoice),
      ),
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
