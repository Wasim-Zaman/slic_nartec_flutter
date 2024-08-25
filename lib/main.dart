import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/theme.dart';
import 'package:slic/cubits/auth/auth_cubit.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/cubits/goods_issue/goods_issue_cubit.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/cubits/item_code/item_code_cubit.dart';
import 'package:slic/cubits/line_item/line_item_cubit.dart';
import 'package:slic/cubits/sales_order/sales_order_cubit.dart';
import 'package:slic/cubits/sales_return/sales_return_cubit.dart';
import 'package:slic/cubits/stock_transfer/stock_transfer_cubit.dart';
import 'package:slic/cubits/trx/trx_cubit.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/home_screen_v2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<ForeignPoCubit>(create: (context) => ForeignPoCubit()),
        BlocProvider<HomeCubit>(create: (context) => HomeCubit()),
        BlocProvider<SalesOrderCubit>(create: (context) => SalesOrderCubit()),
        BlocProvider<LineItemCubit>(create: (context) => LineItemCubit()),
        BlocProvider(create: (context) => StockTransferCubit()),
        BlocProvider(create: (context) => ItemCodeCubit()),
        BlocProvider(create: (context) => GoodsIssueCubit()),
        BlocProvider(create: (context) => SalesReturnCubit()),
        BlocProvider(create: (context) => TrxCubit()),
      ],
      child: MaterialApp(
        title: 'SLIC',
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
