import 'package:flutter/material.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/foreign_po/foreign_po_screen.dart';
import 'package:slic/view/widgets/menu_card.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.3,
          children: [
            MenuCard(
              title: 'Foreign PO',
              iconPath: AppAssets.foreignPo,
              onTap: () {
                Navigation.push(context, const ForeignPoScreen());
              },
            ),
            MenuCard(
              title: 'Sales Order',
              iconPath: AppAssets.salesOrder,
              onTap: () {
                // Add your onTap action here
              },
            ),
            MenuCard(
              title: 'Direct Sales Return',
              iconPath: AppAssets.directSalesReturn,
              onTap: () {
                // Add your onTap action here
              },
            ),
            MenuCard(
              title: 'Stocks Transfer',
              iconPath: AppAssets.stockesTransfer,
              onTap: () {
                // Add your onTap action here
              },
            ),
            MenuCard(
              title: 'Sales Return Invoice',
              iconPath: AppAssets.salesReturnInvoice,
              onTap: () {
                // Add your onTap action here
              },
            ),
            MenuCard(
              title: 'Goods Issue\n(Production to FG)',
              iconPath: AppAssets.goodsIssue,
              onTap: () {
                // Add your onTap action here
              },
            ),
          ],
        ),
      ),
    );
  }
}
