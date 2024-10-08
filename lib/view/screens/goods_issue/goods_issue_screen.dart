import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/goods_issue/goods_issue_cubit.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class GoodsIssueScreen extends StatefulWidget {
  const GoodsIssueScreen({super.key});

  @override
  State<GoodsIssueScreen> createState() => _GoodsIssueScreenState();
}

class _GoodsIssueScreenState extends State<GoodsIssueScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    GoodsIssueCubit.get(context).init();
    final goodsIssueCubit = GoodsIssueCubit.get(context);
    await goodsIssueCubit.getTransactionCodes();
    setState(() {
      GoodsIssueCubit.get(context).setDate(DateTime.now());
      ItemCodeCubit.get(context).itemCodes.clear();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    GoodsIssueCubit.get(context).dispose();
  }

  Widget _buildDropdown({
    required String title,
    required List<String> options,
    required String? defaultValue,
    required ValueChanged<String?> onChanged,
    String? hintText,
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
                      DataCell(Text(e.productSize.toString())),
                      DataCell(Text(e.itemQty.toString())),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
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
              GoodsIssueCubit.get(context).quantity = int.tryParse(value) ?? 1;
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
                  qty: GoodsIssueCubit.get(context).quantity,
                  size: GoodsIssueCubit.get(context).size,
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
    GoodsIssueCubit.get(context).submitGoods(
      itemCodes: ItemCodeCubit.get(context).itemCodes,
      fromLocationCode: HomeCubit.get(context).fromLocationCode,
      toLocationCode: HomeCubit.get(context).toLocationCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Goods Issue"),
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
                hintText: "Transaction",
                title: "Transaction",
                // options: goodsIssueCubit.transactionCodes
                //     .where((element) =>
                //         element.listOfTransactionCod?.tXNNAME != null)
                //     .map((e) => e.listOfTransactionCod!.tXNNAME.toString())
                //     .toSet()
                //     .toList(),
                options: ['DPWO', 'SPWO', 'PWO'],
                defaultValue: GoodsIssueCubit.get(context).transactionCode,
                // defaultValue:   GoodsIssueCubit.get(context).transactionName,
                // onChanged: (value) {
                //   setState(() {
                //       GoodsIssueCubit.get(context).transactionName = value!;
                //       GoodsIssueCubit.get(context).transactionCode =   GoodsIssueCubit.get(context)
                //         .transactionCodes
                //         .firstWhere((element) =>
                //             element.listOfTransactionCod!.tXNNAME == value)
                //         .listOfTransactionCod!
                //         .tXNCODE;
                //   });
                // },
                onChanged: (value) {
                  setState(() {
                    GoodsIssueCubit.get(context).transactionCode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                title: "Location Code",
                options: HomeCubit.get(context)
                    .slicLocations
                    .where((element) =>
                        element.locationMaster?.lOCNNAME != null &&
                        element.locationMaster!.lOCNCODE != null)
                    .map((e) =>
                        "${e.locationMaster!.lOCNCODE} -- ${e.locationMaster!.lOCNNAME}")
                    .toSet()
                    .toList(),
                // defaultValue:     HomeCubit.get(context).location,
                defaultValue: HomeCubit.get(context).fromLocation == null
                    ? null
                    : "${HomeCubit.get(context).fromLocationCode!} -- ${HomeCubit.get(context).fromLocation!}",
                onChanged: (value) {
                  setState(() {
                    HomeCubit.get(context).fromLocationCode =
                        value?.split(" -- ")[0];
                    HomeCubit.get(context).fromLocation =
                        value?.split(" -- ")[1];
                  });
                },
              ),
              // const SizedBox(height: 16),
              // _buildDropdown(
              //   title: "To Location",
              //   options: homeCubit.slicLocations
              //       .where((element) =>
              //           element.locationMaster?.lOCNNAME != null &&
              //           element.locationMaster!.lOCNCODE != null)
              //       .map((e) =>
              //           "${e.locationMaster!.lOCNCODE} -- ${e.locationMaster!.lOCNNAME}")
              //       .toSet()
              //       .toList(),
              //   // defaultValue: homeCubit.location,
              //   defaultValue: homeCubit.toLocation == null
              //       ? null
              //       : "${homeCubit.toLocationCode!} -- ${homeCubit.toLocation!}",
              //   onChanged: (value) {
              //     setState(() {
              //       homeCubit.toLocationCode = value?.split(" -- ")[0];
              //       homeCubit.toLocation = value?.split(" -- ")[1];
              //     });
              //   },
              // ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text("Date"),
                  const SizedBox(width: 8),
                  BlocBuilder<GoodsIssueCubit, GoodsIssueState>(
                    buildWhen: (previous, current) =>
                        current is GoodsIssueDateChanged,
                    builder: (context, state) {
                      final date = GoodsIssueCubit.get(context).date;
                      return Expanded(
                        child: TextFieldWidget(
                          controller: date,
                          readOnly: true,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      // show date picker
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      ).then((value) {
                        if (value != null) {
                          GoodsIssueCubit.get(context).setDate(value);
                        }
                      });
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      title: "Box Quantity",
                      initialValue:
                          GoodsIssueCubit.get(context).boxQuantity.toString(),
                      onChanged: (value) {
                        setState(() {
                          GoodsIssueCubit.get(context).boxQuantity =
                              int.tryParse(value) ?? 1;
                        });
                      },
                    ),
                  ),
                  // const SizedBox(width: 16),
                  // Expanded(
                  //   child: _buildTextField(
                  //     title: "Size",
                  //     initialValue: goodsIssueCubit.size.toString(),
                  //     onChanged: (value) {
                  //       setState(() {
                  //         goodsIssueCubit.size = int.tryParse(value) ?? 1;
                  //       });
                  //     },
                  //   ),
                  // ),
                  // const SizedBox(width: 16),
                  // Expanded(
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const Text("Type"),
                  //       DropdownButtonFormField<String>(
                  //         value: goodsIssueCubit.type,
                  //         items: <String>['U'].map((String value) {
                  //           return DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value),
                  //           );
                  //         }).toList(),
                  //         onChanged: (String? newValue) {
                  //           setState(() {
                  //             goodsIssueCubit.type = newValue!;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                  // Container(
                  //   padding: const EdgeInsets.all(8.0),
                  //   decoration: const BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(8)),
                  //     color: Colors.white,
                  //   ),
                  //   child: Text(
                  //     "Total ${GoodsIssueCubit.get(context).total}",
                  //   ),
                  // ),
                  // const Spacer(),
                  BlocConsumer<GoodsIssueCubit, GoodsIssueState>(
                    listener: (context, state) {
                      if (state is GoodsIssuePostSuccess) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Success",
                                textAlign: TextAlign.center,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(state.message),
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
                      } else if (state is GoodsIssuePostError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(message: state.errorMessage),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is GoodsIssuePostLoading) {
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
