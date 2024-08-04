import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/cubits/stock_transfer/stock_transfer_cubit.dart';
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
    StockTransferCubit.get(context).getTransactionCodes();
    ItemCodeCubit.get(context).itemCodes.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    StockTransferCubit.get(context).dispose();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Transfer"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Transaction"),
              const SizedBox(height: 4),
              BlocBuilder<StockTransferCubit, StockTransferState>(
                builder: (context, state) {
                  return CustomDropdownButton(
                    options: StockTransferCubit.get(context)
                        .transactionCodes
                        .where((element) =>
                            element.listOfTransactionCod?.tXNNAME != null)
                        .map((e) => e.listOfTransactionCod!.tXNNAME.toString())
                        .toSet()
                        .toList(),
                    defaultValue:
                        StockTransferCubit.get(context).transactionName,
                    onChanged: (p0) {
                      StockTransferCubit.get(context).transactionName =
                          p0.toString();
                      StockTransferCubit.get(context).transactionCode =
                          StockTransferCubit.get(context)
                              .transactionCodes
                              .firstWhere((element) =>
                                  element.listOfTransactionCod!.tXNNAME == p0)
                              .listOfTransactionCod!
                              .tXNCODE;
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("From Location"),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return CustomDropdownButton(
                              options: HomeCubit.get(context)
                                  .slicLocations
                                  .where((element) =>
                                      element.locationMaster?.lOCNNAME != null)
                                  .map((e) =>
                                      e.locationMaster!.lOCNNAME.toString())
                                  .toSet()
                                  .toList(),
                              defaultValue: HomeCubit.get(context).fromLocation,
                              onChanged: (p0) {
                                HomeCubit.get(context).fromLocation =
                                    p0.toString();
                                HomeCubit.get(context).fromLocationCode =
                                    HomeCubit.get(context)
                                        .slicLocations
                                        .firstWhere((element) =>
                                            element.locationMaster!.lOCNNAME ==
                                            p0)
                                        .locationMaster!
                                        .lOCNCODE;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("To Location"),
                        BlocBuilder<HomeCubit, HomeState>(
                          builder: (context, state) {
                            return CustomDropdownButton(
                              options: HomeCubit.get(context)
                                  .slicLocations
                                  .where((element) =>
                                      element.locationMaster?.lOCNNAME != null)
                                  .map((e) =>
                                      e.locationMaster!.lOCNNAME.toString())
                                  .toSet()
                                  .toList(),
                              defaultValue: HomeCubit.get(context).toLocation,
                              onChanged: (p0) {
                                HomeCubit.get(context).toLocation =
                                    p0.toString();
                                HomeCubit.get(context).toLocationCode =
                                    HomeCubit.get(context)
                                        .slicLocations
                                        .firstWhere((element) =>
                                            element.locationMaster!.lOCNNAME ==
                                            p0)
                                        .locationMaster!
                                        .lOCNCODE;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Box Quantity"),
                        TextFieldWidget(
                          initialValue: StockTransferCubit.get(context)
                              .boxQuantity
                              .toString(),
                          // keyboardType: TextInputType.number,
                          filledColor: ColorPallete.accent.withOpacity(0.7),
                          onChanged: (value) {
                            setState(() {
                              StockTransferCubit.get(context).boxQuantity =
                                  int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Size"),
                        TextFieldWidget(
                          initialValue:
                              StockTransferCubit.get(context).size.toString(),
                          onChanged: (value) {
                            setState(() {
                              StockTransferCubit.get(context).size =
                                  int.tryParse(value) ?? 1;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Type"),
                        DropdownButtonFormField<String>(
                          value: StockTransferCubit.get(context).type,
                          items: <String>['U', 'Type1', 'Type2']
                              .map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              StockTransferCubit.get(context).type = newValue!;
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
                filledColor: ColorPallete.accent.withOpacity(0.7),
                onChanged: (value) {
                  ItemCodeCubit.get(context).gtin = value;
                },
                onEditingComplete: () {
                  // show dialog to get quantity
                  showAdaptiveDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Enter Quantity"),
                          content: TextFieldWidget(
                            hintText: "Enter Quantity",
                            filledColor: ColorPallete.accent.withOpacity(0.7),
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
                      });
                  // ItemCodeCubit.get(context).getItemCodeByGtin();
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<ItemCodeCubit, ItemCodeState>(
                buildWhen: (previous, current) => current is ItemCodeSuccess,
                builder: (context, state) {
                  return Expanded(
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor:
                              WidgetStateProperty.all(Colors.blueGrey),
                          dataRowColor:
                              WidgetStateProperty.all(Colors.lightBlue[50]),
                          columns: const <DataColumn>[
                            DataColumn(
                              label: Text(
                                'ITEMCODE',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Size',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Qty',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                          rows: ItemCodeCubit.get(context).itemCodes.map(
                            (e) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(e.itemCode ?? '')),
                                  DataCell(Text(e.size.toString())),
                                  DataCell(Text(e.itemQty.toString())),
                                ],
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BlocBuilder<StockTransferCubit, StockTransferState>(
                    builder: (context, state) {
                      if (state is StockTransferPostLoading) {
                        return const LoadingWidget();
                      }
                      return AppButton(
                        text: "Save & Submit",
                        onPressed: () {
                          StockTransferCubit.get(context).transferStock(
                            itemCodes: ItemCodeCubit.get(context).itemCodes,
                            fromLocationCode:
                                HomeCubit.get(context).fromLocationCode,
                            toLocationCode: HomeCubit.get(context).toLocation,
                          );
                        },
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
