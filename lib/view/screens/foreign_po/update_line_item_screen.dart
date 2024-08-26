import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/models/slic_po_model.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class UpdateLineItemScreen extends StatefulWidget {
  final SlicLineItemModel lineItem;
  final SlicPOModel selectedPO;
  const UpdateLineItemScreen(
      {super.key, required this.lineItem, required this.selectedPO});

  @override
  State<UpdateLineItemScreen> createState() => _UpdateLineItemScreenState();
}

class _UpdateLineItemScreenState extends State<UpdateLineItemScreen> {
  final poDateController = TextEditingController();
  final supplierController = TextEditingController();
  final descriptionController = TextEditingController();
  final sizeController = TextEditingController();
  final balanceQtyController = TextEditingController();
  final receivedQuantityController = TextEditingController();
  final poQtyController = TextEditingController();

  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // poDateController.text = widget.lineItem.listOfPOItem?.gRADE ?? '';
    // supplierController.text =
    //     widget.lineItem.listOfPOItem!.iTEMSYSID.toString();
    // descriptionController.text = widget.lineItem.listOfPOItem!.iTEMNAME ?? '';
    // sizeController.text = widget.lineItem.listOfPOItem!.iTEMCODE ?? '';
    // balanceQtyController.text = widget.lineItem.listOfPOItem!.pOQTY.toString();
    receivedQuantityController.text =
        widget.lineItem.listOfPOItem!.rECEIVEDQTY.toString();
    // poQtyController.text = widget.lineItem.listOfPOItem!.uOM ?? '';

    ForeignPoCubit.get(context).getItemCodeByItemSKU(
        // widget.selectedPO.listOfPO?.dOCNO.toString(),
        // widget.lineItem.listOfPOItem?.iTEMCODE.toString(),
        "86679EH");
    super.initState();
  }

  @override
  void dispose() {
    poDateController.dispose();
    supplierController.dispose();
    sizeController.dispose();
    descriptionController.dispose();
    balanceQtyController.dispose();
    receivedQuantityController.dispose();
    poQtyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign GRN'),
      ),
      body: BlocConsumer<ForeignPoCubit, ForeignPoState>(
        listener: (context, state) {
          if (state is ForeignPoGetItemCodeByItemSKUError) {
            showTopSnackBar(
              Overlay.of(context),
              CustomSnackBar.error(message: state.error),
            );
          }
        },
        builder: (context, state) {
          if (state is ForeignPoGetItemCodeByItemSKULoading) {
            return const LoadingWidget();
          } else if (state is ForeignPoGetItemCodeByItemSKUSuccess) {
            return Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("PO Date"),
                      TextFieldWidget(
                        initialValue: state.data.productionDate,
                        // controller: poDateController,
                        hintText: "PO Date",
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      const Text("Supplier"),
                      TextFieldWidget(
                        initialValue: state.data.wHLocation,
                        // controller: supplierController,
                        hintText: "Supplier",
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      const Text("Description"),
                      TextFieldWidget(
                        initialValue: state.data.itemCode,
                        // controller: descriptionController,
                        hintText: "Description",
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      const Text("Size"),
                      TextFieldWidget(
                        initialValue: state.data.size.toString(),
                        // controller: sizeController,
                        hintText: "Size",
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      const Text("PO Quantity"),
                      TextFieldWidget(
                        initialValue: state.data.itemQty.toString(),
                        // controller: poQtyController,
                        hintText: "PO Quantity",
                        readOnly: true,
                      ),
                      const Text("Balance Quantity"),
                      TextFieldWidget(
                        initialValue: state.data.itemQty.toString(),
                        // controller: balanceQtyController,
                        hintText: "Balance Quantity",
                        readOnly: true,
                      ),
                      const SizedBox(height: 8),
                      const Text("Quantity Received"),
                      TextFieldWidget(
                        controller: receivedQuantityController,
                        hintText: "Quantity Received",
                        filledColor: ColorPallete.accent.withOpacity(0.6),
                        validator: (value) {
                          // Check if value is null or empty
                          if (value == null || value.isEmpty) {
                            return 'Please enter a value';
                          }

                          // Try parsing the value to a number
                          final parsedValue = num.tryParse(value);
                          final parsedPo =
                              num.tryParse(balanceQtyController.text);

                          // Check if parsing failed (meaning it's not a number)
                          if (parsedValue == null) {
                            return 'Please enter a valid number';
                          }

                          // Check if the value is negative
                          if (parsedValue < 0) {
                            return 'Negative values are not allowed';
                          }

                          // Check if the value is greater than 80
                          if (parsedPo != null && parsedValue > parsedPo) {
                            return 'Value should not be greater than PO Quantity';
                          }

                          // If all checks pass, return null (indicating the value is valid)
                          return null;
                        },
                      ),
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate the form
                              if (!_formKey.currentState!.validate()) {
                                return;
                              }
                              // Save changes to the line item
                              LineItemCubit.get(context).updateSlicLineItem(
                                SlicLineItemModel(
                                  listOfPOItem: ListOfPOItem(
                                    gRADE: poDateController.text,
                                    iTEMSYSID:
                                        int.parse(supplierController.text),
                                    iTEMNAME: descriptionController.text,
                                    iTEMCODE: sizeController.text,
                                    pOQTY: int.parse(balanceQtyController.text),
                                    rECEIVEDQTY:
                                        receivedQuantityController.text,
                                    uOM: poQtyController.text,
                                  ),
                                ),
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is ForeignPoGetItemCodeByItemSKUError) {
            return Center(
              child: Text(state.error),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
