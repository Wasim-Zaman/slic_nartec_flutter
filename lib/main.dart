import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/core/theme.dart';
import 'package:slic/cubits/auth/auth_cubit.dart';
import 'package:slic/cubits/foreign_po/foreign_po_cubit.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/home_screen.dart';

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
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(create: (context) => ForeignPoCubit()),
      ],
      child: MaterialApp(
        title: 'SLIC',
        theme: AppTheme.theme,
        home: const HomeScreen(),
      ),
    );
  }
}
