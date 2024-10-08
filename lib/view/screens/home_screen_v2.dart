import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/cubits/auth/auth_cubit.dart';
import 'package:slic/cubits/home/home_cubit.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/auth/login_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/dropdown/dropdown_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    animate();
    AuthCubit.get(context).slicLogin();
  }

  animate() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WBS PRO 2.0'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Image.asset(AppAssets.wearhouseBanner),
                  ),
                ),
                const SizedBox(height: 16.0),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return CustomDropdownButton(
                      hintText: "Select Company",
                      items: HomeCubit.get(context)
                          .slicCompanies
                          .where((element) =>
                              element.companyMaster?.cOMPNAME != null)
                          .map((e) => e.companyMaster!.cOMPNAME.toString())
                          .toSet()
                          .toList(),
                      defaultValue: HomeCubit.get(context).company,
                      onChanged: (p0) {
                        HomeCubit.get(context).company = p0.toString();
                        HomeCubit.get(context).companyCode =
                            HomeCubit.get(context)
                                .slicCompanies
                                .firstWhere((element) =>
                                    element.companyMaster!.cOMPNAME == p0)
                                .companyMaster!
                                .cOMPCODE;
                        SharedStorage.setCompany(p0.toString());
                        SharedStorage.setCompanyCode(
                            HomeCubit.get(context).companyCode.toString());
                      },
                    );
                  },
                ),
                const SizedBox(height: 8.0),
                BlocBuilder<HomeCubit, HomeState>(
                  builder: (context, state) {
                    return CustomDropdownButton(
                      hintText: "Select Location",
                      items: HomeCubit.get(context)
                          .slicLocations
                          .where((element) =>
                              element.locationMaster?.lOCNCODE != null)
                          .map((e) => "${e.locationMaster!.lOCNCODE}")
                          .toSet()
                          .toList(),
                      defaultValue: HomeCubit.get(context).locationCode,
                      onChanged: (p0) {
                        HomeCubit.get(context).locationCode = p0.toString();
                        HomeCubit.get(context).location = HomeCubit.get(context)
                            .slicLocations
                            .firstWhere((element) =>
                                element.locationMaster!.lOCNCODE == p0)
                            .locationMaster!
                            .lOCNNAME;

                        SharedStorage.setLocation(
                            HomeCubit.get(context).location.toString());
                        SharedStorage.setLocationCode(p0.toString());
                      },
                    );
                  },
                ),
                const SizedBox(height: 16.0),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AppButton(
                      text: "Proceed",
                      onPressed: () {
                        if (HomeCubit.get(context).company == null ||
                            HomeCubit.get(context).location == null) {
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.info(
                              message:
                                  "Please select company and location to proceed",
                            ),
                          );
                          return;
                        }
                        Navigation.push(context, const LoginScreen());
                      }),
                ),
                const SizedBox(height: 16.0),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: AppButton(
                    text: "Close",
                    onPressed: () {
                      Navigation.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: 0,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthSlicLoginSuccess) {
                  HomeCubit.get(context).getSlicCompanies();
                  HomeCubit.get(context).getSlicLocations();
                }
              },
              listenWhen: (previous, current) =>
                  current is AuthSlicLoginSuccess,
              builder: (context, state) {
                if (state is AuthSlicLoginLoading) {
                  return const LoadingWidget();
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAnimatedText(String text) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
