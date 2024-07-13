import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slic/services/api_service.dart';

part 'auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of<AuthCubit>(context);

  // Variables
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login(String email, String password) async {
    emit(AuthLoginLoading());
    try {
      final response = await ApiService.login(email, password);
      if (response.success) {
        emit(AuthLoginSuccess());
      } else {
        emit(AuthLoginError(response.message));
      }
    } catch (e) {
      print(e);
      emit(AuthLoginError(e.toString()));
    }
  }
}
