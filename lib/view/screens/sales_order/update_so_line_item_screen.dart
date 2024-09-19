import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/so_line_item_model.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class UpdateSoLineItemScreen extends StatefulWidget {
  final SoLineItemModel lineItem;
  const UpdateSoLineItemScreen({super.key, required this.lineItem});

  @override
  State<UpdateSoLineItemScreen> createState() => _UpdateSoLineItemScreenState();
}

class _UpdateSoLineItemScreenState extends State<UpdateSoLineItemScreen> {
  final gradeController = TextEditingController();
  final itemSysIdController = TextEditingController();
  final itemNameController = TextEditingController();
  final itemCodeController = TextEditingController();
  final poQuantityController = TextEditingController();
  final receivedQuantityController = TextEditingController();
  final uomController = TextEditingController();

  // form key
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    gradeController.text = widget.lineItem.listOfSOItem?.gRADE ?? '';
    itemSysIdController.text =
        widget.lineItem.listOfSOItem!.iTEMSYSID.toString();
    itemNameController.text = widget.lineItem.listOfSOItem!.iTEMNAME ?? '';
    itemCodeController.text = widget.lineItem.listOfSOItem!.iTEMCODE ?? '';
    poQuantityController.text = widget.lineItem.listOfSOItem!.iNVQTY.toString();
    receivedQuantityController.text =
        widget.lineItem.listOfSOItem!.iNVQTY.toString();
    uomController.text = widget.lineItem.listOfSOItem!.uOM ?? '';
    super.initState();
  }

  @override
  void dispose() {
    gradeController.dispose();
    itemSysIdController.dispose();
    itemCodeController.dispose();
    itemNameController.dispose();
    poQuantityController.dispose();
    receivedQuantityController.dispose();
    uomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign GRN'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const Text("Grade"),
                // TextFieldWidget(
                //   controller: gradeController,
                //   hintText: "Grade",
                //   readOnly: true,
                // ),
                // const SizedBox(height: 8),
                // const Text("Item Sys Id"),
                // TextFieldWidget(
                //   controller: itemSysIdController,
                //   hintText: "Item Sys Id",
                //   readOnly: true,
                // ),
                // const SizedBox(height: 8),
                // const Text("Item Name"),
                // TextFieldWidget(
                //   controller: itemNameController,
                //   hintText: "Item Name",
                //   readOnly: true,
                // ),
                // const SizedBox(height: 8),
                // const Text("Item Code"),
                // TextFieldWidget(
                //   controller: itemCodeController,
                //   hintText: "Item Code",
                //   readOnly: true,
                // ),
                // const SizedBox(height: 8),
                // const Text("UOM"),
                // TextFieldWidget(
                //   controller: uomController,
                //   hintText: "UOM",
                //   readOnly: true,
                // ),
                const Text("PO Quantity"),
                TextFieldWidget(
                  // controller: poQuantityController,
                  initialValue: widget.lineItem.listOfSOItem?.iNVQTY ?? '',
                  hintText: "PO Quantity",
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                const Text("Quantity Received"),
                TextFieldWidget(
                  controller: receivedQuantityController,
                  hintText: "Received Quantity",
                  filledColor: ColorPallete.accent.withOpacity(0.6),
                  validator: (value) {
                    // Check if value is null or empty
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }

                    // Try parsing the value to a number
                    final parsedValue = num.tryParse(value);
                    final parsedPo = num.tryParse(poQuantityController.text);

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
                        LineItemCubit.get(context).updateSOSlicLineItem(
                          SoLineItemModel(
                            listOfSOItem: ListOfSOItem(
                              gRADE: gradeController.text,
                              iTEMSYSID: int.parse(itemSysIdController.text),
                              iTEMNAME: itemNameController.text,
                              iTEMCODE: itemCodeController.text,
                              iNVQTY: receivedQuantityController.text,
                              sOQTY: int.parse(receivedQuantityController.text),
                              uOM: uomController.text,
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
      ),
    );
  }
}
