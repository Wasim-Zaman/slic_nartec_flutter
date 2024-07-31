import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreign GRN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Grade"),
              TextFieldWidget(
                controller: gradeController,
                hintText: "Grade",
              ),
              const SizedBox(height: 8),
              const Text("Item Sys Id"),
              TextFieldWidget(
                controller: itemSysIdController,
                hintText: "Item Sys Id",
              ),
              const SizedBox(height: 8),
              const Text("Item Name"),
              TextFieldWidget(
                controller: itemNameController,
                hintText: "Item Name",
              ),
              const SizedBox(height: 8),
              const Text("Item Code"),
              TextFieldWidget(
                controller: itemCodeController,
                hintText: "Item Code",
              ),
              const SizedBox(height: 8),
              const Text("PO Quantity"),
              TextFieldWidget(
                controller: poQuantityController,
                hintText: "PO Quantity",
              ),
              const SizedBox(height: 8),
              const Text("Received Quantity"),
              TextFieldWidget(
                controller: receivedQuantityController,
                hintText: "Received Quantity",
              ),
              const SizedBox(height: 8),
              const Text("UOM"),
              TextFieldWidget(
                controller: uomController,
                hintText: "UOM",
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
