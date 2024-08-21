import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';

class SelectedInvoiceScreen extends StatelessWidget {
  const SelectedInvoiceScreen({super.key});

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
            const Text('Select Transaction Code'),
            const SizedBox(height: 8),
            const TextFieldWidget(readOnly: true),
            const SizedBox(height: 16),
            const Text('SO Date'),
            const SizedBox(height: 8),
            const TextFieldWidget(readOnly: true),
            const SizedBox(height: 16),
            const Text('Customer'),
            const SizedBox(height: 8),
            const TextFieldWidget(readOnly: true),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Item Code'),
                      SizedBox(height: 8),
                      TextFieldWidget(readOnly: true),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Size'),
                      SizedBox(height: 8),
                      TextFieldWidget(readOnly: true),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Description'),
            const SizedBox(height: 8),
            const TextFieldWidget(
              readOnly: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Invoice Quantity'),
                      SizedBox(height: 8),
                      TextFieldWidget(readOnly: true),
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
                AppButton(text: "Back"),
                AppButton(text: "Save"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
