import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/cubits/auth/auth_cubit.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/shared_storage.dart';
import 'package:slic/view/screens/main_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SLIC WBS'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            Image.asset(
              AppAssets.logo,
              height: 100,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Login ID',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            TextFieldWidget(
              controller: AuthCubit.get(context).emailController,
              hintText: 'Enter your login ID',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Password',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            TextFieldWidget(
              controller: AuthCubit.get(context).passwordController,
              hintText: 'Enter your password',
              passwordField: true,
            ),
            const SizedBox(height: 16.0),
            BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is AuthLoginSuccess) {
                  SharedStorage.setEmail(
                    AuthCubit.get(context).emailController.text.trim(),
                  ).then((value) {
                    Navigation.push(context, const MainScreen());
                  });
                } else if (state is AuthLoginError) {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.info(message: state.message),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoginLoading) {
                  return const SizedBox(
                    width: double.infinity,
                    child: LoadingWidget(),
                  );
                }
                return AppButton(
                  text: 'Login',
                  onPressed: () {
                    if (AuthCubit.get(context).emailController.text.isEmpty &&
                        AuthCubit.get(context)
                            .passwordController
                            .text
                            .isEmpty) {
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                          message:
                              "Please enter your login ID and password to proceed",
                        ),
                      );
                      return;
                    }
                    final email = AuthCubit.get(context).emailController.text;
                    final password =
                        AuthCubit.get(context).passwordController.text;
                    AuthCubit.get(context).login(email, password);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
