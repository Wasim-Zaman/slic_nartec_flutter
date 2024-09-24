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

class CustomerQuotationScreen extends StatefulWidget {
  const CustomerQuotationScreen({super.key});

  @override
  State<CustomerQuotationScreen> createState() =>
      _CustomerQuotationScreenState();
}

class _CustomerQuotationScreenState extends State<CustomerQuotationScreen> {
  final _formKey = GlobalKey<FormState>();

  final cqCubit = CustomerCubit();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() async {
    await HomeCubit.get(context).getCustomers();
    await HomeCubit.get(context).getSalesman();
    final goodsIssueCubit = GoodsIssueCubit.get(context);
    await goodsIssueCubit.getTransactionCodes(txnType: "SQUOT");
    setState(() {
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
        } else if (state is ItemCodeRateSuccess) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(message: "Item rate updated"),
          );
        } else if (state is ItemCodeRateError) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(message: state.error),
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
      cqCubit.addCustomerQuotation(ItemCodeCubit.get(context).itemCodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customer Quotation")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Expanded(
                  child: _buildDropdown(
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildDropdown(
                    hintText: "Salesman",
                    title: "Salesman",
                    options: HomeCubit.get(context)
                        .salesmen
                        .where((element) =>
                            element.lISTOFSALESMANCODE?.sMCODE != null)
                        .map((e) => e.lISTOFSALESMANCODE!.sMCODE.toString())
                        .toSet()
                        .toList(),
                    defaultValue: cqCubit.salesman,
                    onChanged: (value) {
                      setState(() {
                        cqCubit.salesman = value;
                      });
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
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
                      defaultValue: cqCubit.location == null
                          ? null
                          : "${cqCubit.locationCode!} -- ${cqCubit.location!}",
                      onChanged: (value) {
                        setState(() {
                          cqCubit.locationCode = value?.split(" -- ")[0];
                          cqCubit.location = value?.split(" -- ")[1];
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: _buildDropdown(
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
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(
                  flex: 2,
                  child: BlocBuilder<HomeCubit, HomeState>(
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
                            HomeCubit.get(context)
                                .getPaymentTerms(cqCubit.customerCode);
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: BlocConsumer<HomeCubit, HomeState>(
                    listener: (context, state) {},
                    builder: (context, state) {
                      if (state is HomeGetPaymentTermsLoading) {
                        return const LoadingWidget();
                      }
                      return _buildDropdown(
                        hintText: "Payment Term",
                        title: "Payment Term",
                        options: HomeCubit.get(context)
                            .paymentTerms
                            .where((element) =>
                                element.lISTOFPAYMENTTERM?.cPTTERMCODE != null)
                            .map((e) =>
                                e.lISTOFPAYMENTTERM!.cPTTERMCODE.toString())
                            .toSet()
                            .toList(),
                        defaultValue: cqCubit.paymentTerm,
                        onChanged: (value) {
                          setState(() {
                            cqCubit.paymentTerm = value;
                          });
                        },
                      );
                    },
                  ),
                ),
              ]),

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

              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      hintText: "CQH_FLEX_01",
                      onChanged: (p0) {
                        cqCubit.flex1 = p0;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFieldWidget(
                      hintText: "CQH_FLEX_02",
                      onChanged: (p0) {
                        cqCubit.flex2 = p0;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      hintText: "VAT",
                      onChanged: (p0) {
                        cqCubit.vat = p0;
                      },
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: TextFieldWidget(
                      hintText: "CQH_FLEX_04",
                      onChanged: (p0) {
                        cqCubit.flex4 = p0;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Delivery",
                onChanged: (p0) {
                  cqCubit.delivery = p0;
                },
              ),
              const SizedBox(height: 16),

              Row(children: [
                Expanded(
                  child: TextFieldWidget(
                    hintText: "Remarks",
                    onChanged: (p0) {
                      cqCubit.remarks = p0;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFieldWidget(
                    hintText: "Fax No",
                    onChanged: (p0) {
                      cqCubit.faxNo = p0;
                    },
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // Row(
              //   children: [
              //     Expanded(
              //       child: TextFieldWidget(
              //         hintText: "RefFromNo",
              //         onChanged: (p0) {
              //           cqCubit.refFromNo = p0;
              //         },
              //       ),
              //     ),
              //     const SizedBox(width: 8.0),
              //     Expanded(
              //       child: TextFieldWidget(
              //         hintText: "RefFrom",
              //         onChanged: (p0) {
              //           cqCubit.refFrom = p0;
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 16),

              TextFieldWidget(
                hintText: "Delivery After Days",
                onChanged: (p0) {
                  cqCubit.deliverAfterDays = p0;
                },
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
                      if (state is CustomerSaveQuotationSuccess) {
                        // Handle success state
                        // showTopSnackBar(
                        //   Overlay.of(context),
                        //   CustomSnackBar.success(message: state.message),
                        // );
                        Navigation.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "SUCCESS",
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
                      } else if (state is CustomerSaveQuotationError) {
                        showTopSnackBar(
                          Overlay.of(context),
                          CustomSnackBar.error(message: state.message),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is CustomerSaveQuotationLoading) {
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
