import 'package:flutter/material.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/view/screens/foreign_po/foreign_po_screen.dart';
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.3,
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
                null,
              ),
              MenuInfo(
                'Direct Sales Return',
                AppAssets.directSalesReturn,
                null,
              ),
              MenuInfo(
                'Stocks Transfer',
                AppAssets.stockesTransfer,
                null,
              ),
              MenuInfo(
                'Sales Return Invoice',
                AppAssets.salesReturnInvoice,
                null,
              ),
              MenuInfo(
                'Goods Issue\n(Production to FG)',
                AppAssets.goodsIssue,
                null,
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

  MenuInfo(this.title, this.iconPath, this.screen);
}
