import 'package:bloc/bloc.dart';
import 'package:enactus/layouts/register_layout/cubit/states.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  enterNextStage(RegisterStates stageState) {
    if (stageState is RegisterInitState)
      emit(RegisterFirstStageCompletedState());
    else if (stageState is RegisterFirstStageCompletedState)
      emit(RegisterSecondStageCompletedState());
  }

  backStage(RegisterStates stageState) {
    if (stageState is RegisterSecondStageCompletedState)
      emit(RegisterFirstStageCompletedState());
    else if (stageState is RegisterFirstStageCompletedState)
      emit(RegisterInitState());
  }

  signUp(
      {required String fullName,
      required String email,
      required String password,
      required String phone,
      required String id,
      required String college,
      required String semester,
      required String teamName,
      required String authority,
      required String position}) async {
    emit(RegisterLoadingState());
    try {
      UserCredential credential =
          await UserFirebase.createUser(email: email, password: password);
      int rank = (await UserFirebase.getUsersLength(teamName)) +1 ;
      UserModel user = UserModel(
          uId: UserFirebase.getUid(),
          fullName: fullName,
          email: email,
          phone: phone,
          id: id,
          college: college,
          semester: semester,
          teamName: authority != HIGH_BOARD_AUTHORITY ? teamName : '',
          authority: authority,
          position: position,
          rank: rank
        );
      try {
        await UserFirebase.storeUserData(user: user, uId: credential.user!.uid);
        emit(RegisterSuccessState());
      } catch (err) {
        credential.user!.delete();
        emit(RegisterErrorState('Check internet connection!'));
      }
    } on FirebaseAuthException catch (err) {
      String errMessage = handleError(err.code);
      emit(RegisterErrorState(errMessage));
    }
  }

  //drop down list
  String collegeValue = '${COLLEGES[0]}';
  String semesterValue = '${SEMESTERS[0]}';
  String teamName = '${TEAMS_NAMES[0]}';

  selectItem(int itemType, String? value) {
    switch (itemType) {
      case 0:
        collegeValue = value!;
        break;
      case 1:
        semesterValue = value!;
        break;
      default:
        teamName = value!;
    }
    emit(OnItemSelectedState());
  }

  //password visibility

  IconData passwordSuffixIcon = Icons.remove_red_eye;
  bool passwordSecure = true;

  changePasswordVisibility() {
    passwordSecure = !passwordSecure;
    passwordSuffixIcon =
        passwordSecure ? Icons.remove_red_eye : Icons.visibility_off;
    emit(RegisterSecureVisibilityChangeState());
  }

  IconData idSuffixIcon = Icons.remove_red_eye;
  bool idSecure = true;

  changeIDVisibility() {
    idSecure = !idSecure;
    idSuffixIcon = idSecure ? Icons.remove_red_eye : Icons.visibility_off;
    emit(RegisterSecureVisibilityChangeState());
  }

  double positionFieldOpacity = 0;

  onAuthorityFiledChange(String value) {
    if (value == HR_CODE || value == ON_BOARD_CODE || value == HIGH_BOARD_CODE)
      positionFieldOpacity = 1;
    else
      positionFieldOpacity = 0;
    emit(RegisterPositionVisibilityChangeState());
  }
}
