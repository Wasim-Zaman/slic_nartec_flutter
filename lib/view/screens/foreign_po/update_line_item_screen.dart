import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/models/slic_line_item_model.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class UpdateLineItemScreen extends StatefulWidget {
  final SlicLineItemModel lineItem;
  const UpdateLineItemScreen({super.key, required this.lineItem});

  @override
  State<UpdateLineItemScreen> createState() => _UpdateLineItemScreenState();
}

class _UpdateLineItemScreenState extends State<UpdateLineItemScreen> {
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
    gradeController.text = widget.lineItem.listOfPOItem?.gRADE ?? '';
    itemSysIdController.text =
        widget.lineItem.listOfPOItem!.iTEMSYSID.toString();
    itemNameController.text = widget.lineItem.listOfPOItem!.iTEMNAME ?? '';
    itemCodeController.text = widget.lineItem.listOfPOItem!.iTEMCODE ?? '';
    poQuantityController.text = widget.lineItem.listOfPOItem!.pOQTY.toString();
    receivedQuantityController.text =
        widget.lineItem.listOfPOItem!.rECEIVEDQTY.toString();
    uomController.text = widget.lineItem.listOfPOItem!.uOM ?? '';
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
                const Text("Grade"),
                TextFieldWidget(
                  controller: gradeController,
                  hintText: "Grade",
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                const Text("Item Sys Id"),
                TextFieldWidget(
                  controller: itemSysIdController,
                  hintText: "Item Sys Id",
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                const Text("Item Name"),
                TextFieldWidget(
                  controller: itemNameController,
                  hintText: "Item Name",
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                const Text("Item Code"),
                TextFieldWidget(
                  controller: itemCodeController,
                  hintText: "Item Code",
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                const Text("UOM"),
                TextFieldWidget(
                  controller: uomController,
                  hintText: "UOM",
                  readOnly: true,
                ),
                const Text("PO Quantity"),
                TextFieldWidget(
                  controller: poQuantityController,
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

                    // Check if parsing failed (meaning it's not a number)
                    if (parsedValue == null) {
                      return 'Please enter a valid number';
                    }

                    // Check if the value is negative
                    if (parsedValue < 0) {
                      return 'Negative values are not allowed';
                    }

                    // Check if the value is greater than 80
                    if (parsedValue > 80) {
                      return 'Value should not be greater than 80';
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
                              gRADE: gradeController.text,
                              iTEMSYSID: int.parse(itemSysIdController.text),
                              iTEMNAME: itemNameController.text,
                              iTEMCODE: itemCodeController.text,
                              pOQTY: int.parse(poQuantityController.text),
                              rECEIVEDQTY: receivedQuantityController.text,
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
