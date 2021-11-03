import 'package:email_validator/email_validator.dart';
import 'package:enactus/layouts/login_layout/cubit/cubit.dart';
import 'package:enactus/layouts/login_layout/cubit/states.dart';
import 'package:enactus/layouts/login_layout/forget_password_screen.dart';
import 'package:enactus/layouts/register_layout/register_layout.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_layout/home_layout.dart';

class LoginLayout extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginSuccessState)
            navigateAndFinish(context, HomeLayout());
          else if (state is LoginErrorState) showToast(state.errorMsg);
        },
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          final screenHeight = getScreenHeight(context);
          final screenWidth = getScreenWidth(context);

          return Scaffold(
            backgroundColor: BLACK_COLOR,
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    screenWidth / 10, screenHeight / 7,  screenWidth / 10, screenWidth / 9),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildLogoImage(),
                      buildVerticalSpace(height: screenHeight / 8),
                      buildDefaultTextField(
                          context: context,
                          enabledOutlineBorder: true,
                          controller: _emailController,
                          label: EMAIL_LABEL,
                          type: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty)  return 'Email is required !';
                            if (!EmailValidator.validate(value))
                              return 'Enter a real email, please !';
                            return null;
                          },
                          focusedOutlineBorder: true),
                      buildVerticalSpace(height: screenHeight / 25),
                      buildDefaultTextField(
                          context: context,
                          enabledOutlineBorder: true,
                          controller: _passwordController,
                          label: PASSWORD_LABEL,
                          type: TextInputType.visiblePassword,
                          isSecure: cubit.passwordSecure,
                          suffixIcon: cubit.passwordSuffixIcon,
                          onSuffixPressed: cubit.changePasswordVisibility,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Password is required!';
                            if (value.length < 8) return 'Wrong password!';
                            return null;
                          },
                          focusedOutlineBorder: true),
                      buildVerticalSpace(height: screenHeight / 25),
                      (state is LoginLoadingState)
                          ? CircularProgressIndicator()
                          : buildDefaultBtn(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  cubit.signIn(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                                }
                              },
                              txt: 'Login',
                              context: context),
                      buildForgetPassText(context, () {
                        navigate(context, ForgetPasswordScreen());
                      }),
                      buildDividerView(padding: screenHeight/22),
                      buildCreatNewAccountRow(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildForgetPassText(context, onPressed()) {
    return buildTextButton(
        onPressed: onPressed, txt: 'Forget password?', context: context);
  }

  Widget buildCreatNewAccountRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Create new',
          style: getTextTheme(context).bodyText1!.copyWith(color: WHITE_COLOR),
        ),
        buildTextButton(
            onPressed: () {
              navigate(context, RegisterLayout());
            },
            txt: 'account',
            context: context)
      ],
    );
  }
}
