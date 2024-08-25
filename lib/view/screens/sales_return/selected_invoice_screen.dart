import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/models/pos_invoice_model.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class SelectedInvoiceScreen extends StatelessWidget {
  final POSInvoiceModel model;
  const SelectedInvoiceScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location: FG101'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Transaction Code'),
            const SizedBox(height: 8),
            TextFieldWidget(
              readOnly: true,
              initialValue: model.transactionCode,
            ),
            const SizedBox(height: 16),
            const Text('SO Date'),
            const SizedBox(height: 8),
            TextFieldWidget(
              readOnly: true,
              initialValue: model.transactionDate,
            ),
            const SizedBox(height: 16),
            const Text('Customer'),
            const SizedBox(height: 8),
            TextFieldWidget(
              readOnly: true,
              initialValue: model.customerCode,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Item Code'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: model.itemSKU,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Size'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: model.itemSize,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Description'),
            const SizedBox(height: 8),
            TextFieldWidget(
              readOnly: true,
              initialValue: model.itemSKU,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice Quantity'),
                      SizedBox(height: 8),
                      TextFieldWidget(
                        readOnly: true,
                        initialValue: model.itemQry.toString(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Return Quantity'),
                      const SizedBox(height: 8),
                      TextFieldWidget(
                        filledColor: ColorPallete.accent.withOpacity(0.6),
                        initialValue: model.itemQry.toString(),
                        onChanged: (value) {
                          // update return quantity
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: AppButton(text: "Back", backgroundColor: Colors.red),
                ),
                SizedBox(width: 16),
                Expanded(child: AppButton(text: "Save")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
