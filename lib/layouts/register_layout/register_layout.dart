import 'package:email_validator/email_validator.dart';
import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/layouts/register_layout/cubit/cubit.dart';
import 'package:enactus/layouts/register_layout/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterLayout extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _idController = TextEditingController();
  final TextEditingController _authorityController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  RegisterStates stageState = RegisterInitState();
  RegisterStates globalState = RegisterInitState();
  double screenHeight = 0.0;

  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if (state is RegisterInitState ||
              state is RegisterFirstStageCompletedState ||
              state is RegisterSecondStageCompletedState)
            stageState = state;
          else {
            if (state is RegisterSuccessState)
              navigateAndFinish(context, HomeLayout());
            else if (state is RegisterErrorState) showToast(state.errorMsg);
          }
        },
        builder: (context, state) {
          RegisterCubit cubit = RegisterCubit.get(context);
          globalState = state;
          screenHeight = getScreenHeight(context);
          screenWidth = getScreenWidth(context);

          return WillPopScope(
            onWillPop: () async {
              if (stageState is RegisterInitState) return true;

              cubit.backStage(stageState);
              return false;
            },
            child: Scaffold(
              backgroundColor: BLACK_COLOR,
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth / 9, 0, 50, screenWidth / 9),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildLogoImage(),
                        buildVerticalSpace(height: screenHeight / 20),
                        getProperRegisterStageLayout(context, cubit),
                        buildVerticalSpace(height: screenHeight / 25),
                        buildHaveAnAccount(context)
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildFirstLayout(context, RegisterCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildDefaultTextField(
            context: context,
            controller: _fullNameController,
            label: FULL_NAME,
            type: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Name is required!';
              return null;
            }),
        buildVerticalSpace(height: screenHeight / 25),
        buildDefaultTextField(
            context: context,
            controller: _emailController,
            label: EMAIL_LABEL,
            type: TextInputType.emailAddress,
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Email is required !';
              if (!EmailValidator.validate(value)) return 'Invalid email !';
              return null;
            }),
        buildVerticalSpace(height: screenHeight / 25),
        buildDefaultTextField(
            context: context,
            controller: _phoneNumController,
            label: PHONE_NUMBER,
            type: TextInputType.phone,
            validator: (String? value) {
              if (value == null || value.isEmpty) return 'Phone is required !';
              if (value.length != 11) return 'Invalid phone !';
              String firstPart = value.substring(0, 3);
              if ((firstPart != '010' &&
                  firstPart != '011' &&
                  firstPart != '012' &&
                  firstPart != '015')) return 'Invalid phone !';
              return null;
            }),
        buildVerticalSpace(height: screenHeight / 25),
        buildDefaultTextField(
            context: context,
            controller: _passwordController,
            type: TextInputType.visiblePassword,
            label: PASSWORD_LABEL,
            isSecure: cubit.passwordSecure,
            suffixIcon: cubit.passwordSuffixIcon,
            onSuffixPressed: cubit.changePasswordVisibility,
            validator: (String? value) {
              if (value == null || value.isEmpty)
                return 'Password is required !';
              if (value.length < 8) return 'Password is very weak !';
              return null;
            }),
        buildVerticalSpace(height: screenHeight / 15),
        buildDefaultBtn(
            onPressed: () {
              if (_formKey.currentState!.validate())
                cubit.enterNextStage(stageState);
            },
            txt: 'Next',
            context: context),
      ],
    );
  }

  buildSecondLayout(context, RegisterCubit cubit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildDefaultTextField(
          context: context,
          controller: _idController,
          label: ID,
          type: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) return 'ID is required!';
            if (value.length != 8) return 'Invalid ID!';
            return null;
          },
          suffixIcon: cubit.idSuffixIcon,
          isSecure: cubit.idSecure,
          onSuffixPressed: cubit.changeIDVisibility,
        ),
        buildVerticalSpace(height: screenHeight / 25),
        buildDropDownField(context, COLLEGES, cubit, 0),
        buildVerticalSpace(height: screenHeight / 25),
        buildDropDownField(context, SEMESTERS, cubit, 1),
        buildVerticalSpace(height: screenHeight / 15),
        buildDefaultBtn(
            onPressed: () {
              if (_formKey.currentState!.validate())
                cubit.enterNextStage(stageState);
            },
            txt: 'Next',
            context: context),
      ],
    );
  }

  buildThirdLayout(context, RegisterCubit cubit, state) {
    return Column(
      children: [
        buildDropDownField(context, TEAMS_NAMES, cubit, 2),
        buildVerticalSpace(height: screenHeight / 25),
        buildDefaultTextField(
            context: context,
            controller: _authorityController,
            label: 'High authority ID (Optional)',
            type: TextInputType.text,
            onChange: (value) {
              cubit.onAuthorityFiledChange(value!);
            },
            validator: (value) {
              if (value!.isNotEmpty &&
                  value != HR_CODE &&
                  value != ON_BOARD_CODE &&
                  value != HIGH_BOARD_CODE) return 'Incorrect code !';

              return null;
            }),
        cubit.positionFieldOpacity==1 ? Column(
          children: [
            buildVerticalSpace(height: screenHeight / 25),
            buildDefaultTextField(
                context: context,
                controller: _positionController,
                label: 'Position title',
                type: TextInputType.text,
                validator: (value) {
                  if (value!.isEmpty) return 'position is required';
                  return null;
                }),
          ],
        ): Container(),
        buildVerticalSpace(height: screenHeight / 15),
        globalState is RegisterLoadingState
            ? CircularProgressIndicator(strokeWidth: 2,)
            : buildDefaultBtn(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    cubit.signUp(
                      fullName: _fullNameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      phone: _phoneNumController.text,
                      id: _idController.text,
                      college: cubit.collegeValue,
                      semester: cubit.semesterValue,
                      teamName: cubit.teamName,
                      authority: getAuthority(_authorityController.text),
                      position: _positionController.text == ''
                          ? 'Member'
                          : _positionController.text,
                    );
                  }
                },
                txt: 'Sign up',
                context: context),
      ],
    );
  }

  getAuthority(String code) {
    return code == HR_CODE
        ? HR_AUTHORITY
        : code == ON_BOARD_CODE
            ? ON_BOARD_AUTHORITY
            : code == HIGH_BOARD_CODE
                ? HIGH_BOARD_AUTHORITY
                : USER_AUTHORITY;
  }

  Widget buildHaveAnAccount(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an ',
          style: getTextTheme(context).bodyText1!.copyWith(color: WHITE_COLOR),
        ),
        buildTextButton(
            onPressed: () {
              navigateAndFinish(context, LoginLayout());
            },
            txt: 'account?',
            context: context)
      ],
    );
  }

  bool collegeChanged = false;
  bool semesterChanged = false;
  bool teamChanged = false;

  buildDropDownField(
      context, List<String> itemList, RegisterCubit cubit, int itemType) {
    return DropdownButtonFormField(
      hint: Text('value'),
      value: itemType == 0
          ? cubit.collegeValue
          : itemType == 1
              ? cubit.semesterValue
              : cubit.teamName,
      items: itemList
          .map((element) => DropdownMenuItem<String>(
                child: Text(element),
                value: element,
              ))
          .toList(),
      onChanged: (String? value) {
        cubit.selectItem(itemType, value);
        itemType == 0
            ? collegeChanged = true
            : itemType == 1
                ? semesterChanged = true
                : teamChanged = true;
      },
      style: getTextTheme(context).bodyText1!.copyWith(color: WHITE_COLOR),
      elevation: 2,
      dropdownColor: Colors.grey[700],
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: WHITE_COLOR, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: WHITE_COLOR, width: 1)),
        labelStyle:
            getTextTheme(context).bodyText1!.copyWith(color: WHITE_COLOR),
        labelText: itemType == 0
            ? 'College'
            : itemType == 1
                ? 'Semester'
                : 'Team name',
      ),
    );
  }

  getProperRegisterStageLayout(context, cubit) {
    Widget myLayout = Column();
    if (stageState is RegisterInitState)
      myLayout = buildFirstLayout(context, cubit);
    else if (stageState is RegisterFirstStageCompletedState)
      myLayout = buildSecondLayout(context, cubit);
    else
      myLayout = buildThirdLayout(context, cubit, stageState);
    return myLayout;
  }
}
