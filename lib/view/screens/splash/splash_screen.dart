// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/home_screen_v2.dart';
import 'package:slic/view/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () async {
      final email = SharedStorage.getEmail();
      if (email != null) {
        HomeCubit.get(context).location = SharedStorage.getLocation();
        HomeCubit.get(context).locationCode = SharedStorage.getLocationCode();
        HomeCubit.get(context).company = SharedStorage.getCompany();
        HomeCubit.get(context).companyCode = SharedStorage.getCompanyCode();

        await HomeCubit.get(context).getSlicCompanies();
        await HomeCubit.get(context).getSlicLocations();

        Navigation.replace(context, const MainScreen());
      } else {
        Navigation.replace(context, const HomeScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/icon.png"),
              const SizedBox(height: 30),
              const Text("Loading..."),
              const SizedBox(height: 30),
              const Text("Version 1.0.0"),
              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
