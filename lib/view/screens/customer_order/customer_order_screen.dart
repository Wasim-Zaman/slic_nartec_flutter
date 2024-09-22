import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/customer/customer_cubit.dart';
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

class CustomerOrderScreen extends StatefulWidget {
  const CustomerOrderScreen({super.key});

  @override
  State<CustomerOrderScreen> createState() => _CustomerOrderScreenState();
}

class _CustomerOrderScreenState extends State<CustomerOrderScreen> {
  final _formKey = GlobalKey<FormState>();

  final cqCubit = CustomerCubit();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await HomeCubit.get(context).getCustomers();
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
    return BlocConsumer<ItemCodeCubit, ItemCodeState>(
      listener: (context, state) {
        if (state is ItemCodeSuccess) {
          ItemCodeCubit.get(context).getItemRate(
            "${state.itemCode?.itemCode}",
            "${cqCubit.customerCode}",
            "${state.itemCode?.productSize}",
          );
        }
      },
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
                  label: Text('Rate', style: TextStyle(color: Colors.white)),
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
                      DataCell(Text(e.rate.toString())),
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
              cqCubit.quantity = int.tryParse(value) ?? 1;
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
                  qty: cqCubit.quantity,
                  size: cqCubit.size,
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
    if (_formKey.currentState!.validate()) {
      cqCubit.saveOrder(ItemCodeCubit.get(context).itemCodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Order")),
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
                options: GoodsIssueCubit.get(context)
                    .transactionCodes
                    .where((element) =>
                        element.listOfTransactionCod?.tXNNAME != null)
                    .map((e) => e.listOfTransactionCod!.tXNCODE.toString())
                    .toSet()
                    .toList(),
                defaultValue: cqCubit.transactionCode,
                onChanged: (value) {
                  setState(() {
                    cqCubit.transactionCode = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                title: "Delivery Location Code",
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
                defaultValue: cqCubit.deliveryLocation == null
                    ? null
                    : "${cqCubit.locationCode!} -- ${cqCubit.location!}",
                onChanged: (value) {
                  setState(() {
                    cqCubit.deliveryLocationCode = value?.split(" -- ")[0];
                    cqCubit.deliveryLocation = value?.split(" -- ")[1];
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdown(
                title: "Sales Location Code",
                options: HomeCubit.get(context)
                    .slicLocations
                    .where((element) =>
                        element.locationMaster?.lOCNNAME != null &&
                        element.locationMaster!.lOCNCODE != null)
                    .map((e) =>
                        "${e.locationMaster!.lOCNCODE} -- ${e.locationMaster!.lOCNNAME}")
                    .toSet()
                    .toList(),
                defaultValue: cqCubit.salesLocation == null
                    ? null
                    : "${cqCubit.salesLocationCode!} -- ${cqCubit.salesLocation!}",
                onChanged: (value) {
                  setState(() {
                    cqCubit.salesLocationCode = value?.split(" -- ")[0];
                    cqCubit.salesLocation = value?.split(" -- ")[1];
                  });
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return _buildDropdown(
                    title: "Customer",
                    options: HomeCubit.get(context)
                        .customers
                        .where((element) =>
                            element.cUSTCODE != null &&
                            element.cUSTNAME != null)
                        .map((e) => "${e.cUSTCODE} -- ${e.cUSTNAME}")
                        .toSet()
                        .toList(),
                    defaultValue: cqCubit.customerCode == null
                        ? null
                        : "${cqCubit.customerCode!} -- ${cqCubit.customerName!}",
                    onChanged: (value) {
                      setState(() {
                        cqCubit.customerCode = value?.split(" -- ")[0];
                        cqCubit.customerName = value?.split(" -- ")[1];
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: 16),
              // Row(
              //   children: [
              //     const Text("Date"),
              //     const SizedBox(width: 8),
              //     BlocBuilder<GoodsIssueCubit, GoodsIssueState>(
              //       buildWhen: (previous, current) =>
              //           current is GoodsIssueDateChanged,
              //       builder: (context, state) {
              //         final date = GoodsIssueCubit.get(context).date;
              //         return Expanded(
              //           child: TextFieldWidget(
              //             controller: date,
              //             readOnly: true,
              //           ),
              //         );
              //       },
              //     ),
              //     const SizedBox(width: 8),
              //     IconButton(
              //       onPressed: () {
              //         GoodsIssueCubit.get(context).setDate();
              //       },
              //       icon: const Icon(Icons.calendar_today),
              //     ),
              //   ],
              // ),
              TextFieldWidget(
                hintText: "Delivery Instruction",
                onChanged: (p0) {
                  cqCubit.deliveryInstruction = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Packing Instruction",
                onChanged: (p0) {
                  cqCubit.packingInstruction = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Billing Instruction",
                onChanged: (p0) {
                  cqCubit.billingInstruction = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Other Details",
                onChanged: (p0) {
                  cqCubit.otherDetails = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Cust Ref Number",
                onChanged: (p0) {
                  cqCubit.custRefNo = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Delivery Mode",
                onChanged: (p0) {
                  cqCubit.modeOfDelivery = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Delivery Contact",
                onChanged: (p0) {
                  cqCubit.deliveryContact = p0;
                },
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "LPO Number",
                onChanged: (p0) {
                  cqCubit.lpoNumber = p0;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  BlocBuilder<CustomerCubit, CustomerState>(
                    bloc: cqCubit,
                    buildWhen: (previous, current) =>
                        current is CustomerDateChanged,
                    builder: (context, state) {
                      final date = cqCubit.deliveryDate;
                      return Expanded(
                        child: TextFieldWidget(
                          controller: date,
                          readOnly: true,
                        ),
                      );
                    },
                  ),
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
                            cqCubit.setDate(value);
                          }
                        });
                      },
                      icon: const Icon(Icons.search)),
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
                  BlocConsumer<CustomerCubit, CustomerState>(
                    bloc: cqCubit,
                    listener: (context, state) {
                      if (state is CustomerSaveOrderSuccess) {
                        Navigation.pop(context);
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
                      } else if (state is CustomerSaveOrderError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(message: state.message),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CustomerSaveOrderLoading) {
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
