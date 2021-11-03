import 'package:bloc/bloc.dart';
import 'package:enactus/layouts/login_layout/cubit/states.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());

  static LoginCubit get(context) => BlocProvider.of(context);

  signIn({required String email, required String password}) async {
    emit(LoginLoadingState());
    try {
      await UserFirebase.signIn(email: email, password: password);
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (err) {
      String errMessage = handleError(err.code);
      emit(LoginErrorState(errMessage));
    }
  }

  resetPassword (String email) async
  {
    await UserFirebase.resetPassword(email);
  }


//password visibility
  IconData passwordSuffixIcon = Icons.remove_red_eye;
  bool passwordSecure = true;

  changePasswordVisibility() {
    passwordSecure = !passwordSecure;
    passwordSuffixIcon = passwordSecure ? Icons.remove_red_eye: Icons.visibility_off;
    emit(LoginSecureVisibilityState());
  }


}
