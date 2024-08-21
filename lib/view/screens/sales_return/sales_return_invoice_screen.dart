import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/cubits/sales_return/sales_return_cubit.dart';
import 'package:slic/cubits/stock_transfer/stock_transfer_cubit.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/foreign_po/update_line_item_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

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
    final cubit = SalesReturnCubit.get(context);
    await cubit.getTransactionCodes();
    setState(() {
      ItemCodeCubit.get(context).itemCodes.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    StockTransferCubit.get(context).dispose();
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
          options: options,
          defaultValue: defaultValue,
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _handleSubmit() {
    // unfocus keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final stockTransferCubit = StockTransferCubit.get(context);

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
              _buildDropdown(
                title: "Select Transaction Code",
                options: stockTransferCubit.transactionCodes
                    .where((element) =>
                        element.listOfTransactionCod?.tXNNAME != null)
                    .map((e) => e.listOfTransactionCod!.tXNNAME.toString())
                    .toSet()
                    .toList(),
                defaultValue: stockTransferCubit.transactionName,
                onChanged: (value) {
                  setState(() {
                    stockTransferCubit.transactionName = value!;
                    stockTransferCubit.transactionCode = stockTransferCubit
                        .transactionCodes
                        .firstWhere((element) =>
                            element.listOfTransactionCod!.tXNNAME == value)
                        .listOfTransactionCod!
                        .tXNCODE;
                  });
                },
              ),
              const SizedBox(height: 16),
              const Text("Enter Transaction Code"),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      onChanged: (value) {
                        ItemCodeCubit.get(context).gtin = value;
                      },
                      onEditingComplete: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.logout)),
                ],
              ),
              SizedBox(
                child: BlocConsumer<LineItemCubit, LineItemState>(
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is LineItemGetBySysIdLoading) {
                      // return const LoadingWidget();
                      return _buildLineItemsTable([]);
                    }
                    return _buildLineItemsTable(
                      LineItemCubit.get(context).slicLineItems,
                    );
                  },
                ),
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

  Widget _buildLineItemsTable(List<SlicLineItemModel> data) {
    LineItemSource dataSource = LineItemSource(data, (SlicLineItemModel item) {
      Navigation.push(context, UpdateLineItemScreen(lineItem: item));
    });
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.white,
      child: PaginatedDataTable(
        columns: const [
          DataColumn(label: Text('gRADE')),
          DataColumn(label: Text('iTEMSYSID')),
          DataColumn(label: Text('iTEMNAME')),
          DataColumn(label: Text('iTEMCODE')),
          DataColumn(label: Text('pOQTY')),
          DataColumn(label: Text('rECEIVEDQTY')),
          DataColumn(label: Text('uOM')),
        ],
        source: dataSource,
        columnSpacing: 20,
        horizontalMargin: 10,
        rowsPerPage: 3,
        showCheckboxColumn: true,
      ),
    );
  }
}

class LineItemSource extends DataTableSource {
  final List<SlicLineItemModel> _data;
  final void Function(SlicLineItemModel) onDoubleTap;

  LineItemSource(this._data, this.onDoubleTap);

  @override
  DataRow getRow(int index) {
    final SlicLineItemModel data = _data[index];
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
          return ColorPallete.background;
        },
      ),
      cells: <DataCell>[
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem?.gRADE ?? ''),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMSYSID.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMNAME.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.iTEMCODE.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.pOQTY.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.rECEIVEDQTY.toString()),
          ),
        ),
        DataCell(
          GestureDetector(
            onDoubleTap: () => onDoubleTap(data),
            child: Text(data.listOfPOItem!.uOM.toString()),
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
