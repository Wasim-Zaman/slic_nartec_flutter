import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/cubits/stock_transfer/stock_transfer_cubit.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class StockTransferScreen extends StatefulWidget {
  const StockTransferScreen({super.key});

  @override
  State<StockTransferScreen> createState() => _StockTransferScreenState();
}

class _StockTransferScreenState extends State<StockTransferScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    ItemCodeCubit.get(context).itemCodes.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    StockTransferCubit.get(context).dispose();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
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
              DropdownButtonFormField<String>(
                value: StockTransferCubit.get(context).transaction,
                decoration: const InputDecoration(labelText: "Transaction"),
                items: <String>['Element 1', 'Element 2', 'Element 3']
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    StockTransferCubit.get(context).transaction = newValue;
                  });
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: StockTransferCubit.get(context).fromLocation,
                      decoration:
                          const InputDecoration(labelText: "From Location"),
                      items: <String>['Location 1', 'Location 2', 'Location 3']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          StockTransferCubit.get(context).fromLocation =
                              newValue;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: StockTransferCubit.get(context).toLocation,
                      decoration:
                          const InputDecoration(labelText: "To Location"),
                      items: <String>['Location A', 'Location B', 'Location C']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          StockTransferCubit.get(context).toLocation = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
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
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFieldWidget(
                      initialValue: StockTransferCubit.get(context).size,
                      onChanged: (value) {
                        setState(() {
                          StockTransferCubit.get(context).size = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: StockTransferCubit.get(context).type,
                      decoration: const InputDecoration(labelText: "Type"),
                      items:
                          <String>['U', 'Type1', 'Type2'].map((String value) {
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
                  ItemCodeCubit.get(context).getItemCodeByGtin();
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
                                  const DataCell(Text("")),
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppButton(text: "Save & Submit"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
