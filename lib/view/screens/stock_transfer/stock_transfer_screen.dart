import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/cubits/stock_transfer/stock_transfer_cubit.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/snackbar.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';

class StockTransferScreen extends StatefulWidget {
  const StockTransferScreen({super.key});

  @override
  State<StockTransferScreen> createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    final stockTransferCubit = StockTransferCubit.get(context);
    await stockTransferCubit.getTransactionCodes();
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
    required String hintText,
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
          hintText: hintText,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String title,
    required String initialValue,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        TextFieldWidget(
          initialValue: initialValue,
          filledColor: ColorPallete.accent.withOpacity(0.6),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    return BlocBuilder<ItemCodeCubit, ItemCodeState>(
      buildWhen: (previous, current) => current is ItemCodeSuccess,
      builder: (context, state) {
        return Container(
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(Colors.blueGrey),
              dataRowColor: WidgetStateProperty.all(Colors.lightBlue[50]),
              columns: const <DataColumn>[
                DataColumn(
                  label:
                      Text('ITEMCODE', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Size', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Qty', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Actions', style: TextStyle(color: Colors.white)),
                ),
              ],
              rows: ItemCodeCubit.get(context).itemCodes.map(
                (e) {
                  return DataRow(
                    cells: [
                      DataCell(Text(e.itemCode ?? '')),
                      DataCell(Text(e.size.toString())),
                      DataCell(Text(e.itemQty.toString())),
                      DataCell(
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              ItemCodeCubit.get(context).itemCodes.remove(e);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showQuantityDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter Quantity"),
          content: TextFieldWidget(
            hintText: "Enter Quantity",
            filledColor: ColorPallete.accent.withOpacity(0.6),
            onChanged: (value) {
              StockTransferCubit.get(context).quantity =
                  int.tryParse(value) ?? 1;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                ItemCodeCubit.get(context).getItemCodeByGtin(
                  qty: StockTransferCubit.get(context).quantity,
                  size: StockTransferCubit.get(context).size,
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _handleSubmit() {
    // unfocus keyboard
    FocusManager.instance.primaryFocus?.unfocus();
    StockTransferCubit.get(context).transferStock(
      itemCodes: ItemCodeCubit.get(context).itemCodes,
      fromLocationCode: HomeCubit.get(context).fromLocationCode,
      toLocationCode: HomeCubit.get(context).toLocationCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stockTransferCubit = StockTransferCubit.get(context);
    final homeCubit = HomeCubit.get(context);

    print(homeCubit.location);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Transfer"),
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
                title: "Transaction",
                hintText: "Select Transaction",
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
              if (homeCubit.slicLocations.isNotEmpty)
                _buildDropdown(
                  title: "From Location",
                  hintText: homeCubit.location ?? '',
                  options: homeCubit.slicLocations
                      .where(
                          (element) => element.locationMaster?.lOCNNAME != null)
                      .map((e) => e.locationMaster!.lOCNNAME.toString())
                      .toSet()
                      .toList(),
                  defaultValue: homeCubit.location,
                  onChanged: (value) {
                    setState(() {
                      homeCubit.fromLocation = value!;
                      homeCubit.fromLocationCode = homeCubit.slicLocations
                          .firstWhere((element) =>
                              element.locationMaster!.lOCNNAME == value)
                          .locationMaster!
                          .lOCNCODE;
                    });
                  },
                ),
              const SizedBox(height: 16),
              if (homeCubit.slicLocations.isNotEmpty)
                _buildDropdown(
                  title: "To Location",
                  hintText: homeCubit.location ?? '',
                  options: homeCubit.slicLocations
                      .where(
                          (element) => element.locationMaster?.lOCNNAME != null)
                      .map((e) => e.locationMaster!.lOCNNAME.toString())
                      .toSet()
                      .toList(),
                  defaultValue: homeCubit.location,
                  onChanged: (value) {
                    setState(() {
                      homeCubit.toLocation = value!;
                      homeCubit.toLocationCode = homeCubit.slicLocations
                          .firstWhere((element) =>
                              element.locationMaster!.lOCNNAME == value)
                          .locationMaster!
                          .lOCNCODE;
                    });
                  },
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      title: "Box Quantity",
                      initialValue: stockTransferCubit.boxQuantity.toString(),
                      onChanged: (value) {
                        setState(() {
                          stockTransferCubit.boxQuantity =
                              int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      title: "Size",
                      initialValue: stockTransferCubit.size.toString(),
                      onChanged: (value) {
                        setState(() {
                          stockTransferCubit.size = int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Type"),
                        CustomDropdownButton(
                          items: <String>['U', 'S', 'L', 'LS'].toList(),
                          defaultValue: stockTransferCubit.type,
                          hintText: "Type",
                          onChanged: (String? newValue) {
                            setState(() {
                              stockTransferCubit.type = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFieldWidget(
                hintText: "Search GTIN number",
                filledColor: ColorPallete.accent.withOpacity(0.6),
                onChanged: (value) {
                  ItemCodeCubit.get(context).gtin = value;
                },
                onEditingComplete: () => _showQuantityDialog(context),
              ),
              const SizedBox(height: 16),
              _buildDataTable(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocConsumer<StockTransferCubit, StockTransferState>(
                    listener: (context, state) {
                      if (state is StockTransferPostSuccess) {
                        // Handle success state
                        CustomSnackbar.show(
                          context: context,
                          message: "Stock transfer submitted ",
                        );
                        Navigation.pop(context);
                      }
                    },
                    buildWhen: (previous, current) =>
                        current is StockTransferPostLoading,
                    builder: (context, state) {
                      if (state is StockTransferPostLoading) {
                        return const LoadingWidget();
                      }
                      return AppButton(
                        text: "Save & Submit",
                        onPressed: _handleSubmit,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
