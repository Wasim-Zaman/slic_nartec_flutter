import 'package:flutter/material.dart';
import 'package:slic/core/color_pallete.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/foreign_po/foreign_po_screen_v3.dart';
import 'package:slic/view/screens/goods_issue/goods_issue_screen.dart';
import 'package:slic/view/screens/home_screen_v2.dart';
import 'package:slic/view/screens/sales_order/sales_order_screen_v3.dart';
import 'package:slic/view/screens/sales_return/sales_return_invoice_screen_v2.dart';
import 'package:slic/view/screens/stock_transfer/stock_transfer_screen.dart';
import 'package:slic/view/widgets/menu_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    initLocalStorage();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  void initLocalStorage() {
    HomeCubit.get(context).location = SharedStorage.getLocation();
    HomeCubit.get(context).company = SharedStorage.getCompany();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
        actions: [
          TextButton(
              onPressed: () {
                // show logout dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // logout logic
                            SharedStorage.clear();
                            Navigation.replace(context, const HomeScreen());
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text(
                "Log out",
                style: TextStyle(color: Colors.white, fontSize: 18),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1,
          children: [
            for (var menu in [
              MenuInfo(
                'Foreign PO',
                AppAssets.foreignPo,
                const ForeignPoScreen(),
              ),
              MenuInfo(
                'Sales Order',
                AppAssets.salesOrder,
                const SalesOrderScreen(),
              ),
              MenuInfo(
                'Direct Sales Return',
                AppAssets.directSalesReturn,
                // const DirectSalesReturnScreen(),
                null,
                color: ColorPallete.border,
              ),
              MenuInfo(
                'Stocks Transfer',
                AppAssets.stockesTransfer,
                const StockTransferScreen(),
              ),
              MenuInfo(
                'Sales Return Invoice',
                AppAssets.salesReturnInvoice,
                const SalesReturnInvoiceScreen(),
              ),
              MenuInfo(
                'Goods Issue\n(Production to FG)',
                AppAssets.goodsIssue,
                const GoodsIssueScreen(),
              ),
            ])
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Transform.scale(
                  scale: _scaleAnimation.value,
                  child: AnimatedOpacity(
                    opacity: _opacityAnimation.value,
                    duration: const Duration(milliseconds: 500),
                    child: MenuCard(
                      title: menu.title,
                      iconPath: menu.iconPath,
                      onTap: () {
                        if (menu.screen != null) {
                          Navigation.push(context, menu.screen!);
                        }
                      },
                      bgColor: menu.color,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MenuInfo {
  final String title;
  final String iconPath;
  final Widget? screen;
  final Color? color;

  MenuInfo(this.title, this.iconPath, this.screen, {this.color});
}
