import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/cubits/auth/auth_cubit.dart';
import 'package:slic/utils/assets.dart';
import 'package:slic/utils/navigation.dart';
import 'package:slic/utils/snackbar.dart';
import 'package:slic/view/screens/main_screen.dart';
import 'package:slic/view/widgets/buttons/app_button.dart';
import 'package:slic/view/widgets/field/text_field_widget.dart';
import 'package:slic/view/widgets/loading/loading_widget.dart';

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
                  Navigation.push(context, const MainScreen());
                } else if (state is AuthLoginError) {
                  CustomSnackbar.show(context: context, message: state.message);
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
