import 'package:flutter/material.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';

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
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Transaction Code',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'SO Date',
              ),
            ),
            const SizedBox(height: 16),
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Customer',
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Item Code',
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Size',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const TextField(
              readOnly: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Invoice Quantity',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.yellow[100],
                      border: const OutlineInputBorder(),
                      labelText: 'Return Quantity',
                    ),
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
