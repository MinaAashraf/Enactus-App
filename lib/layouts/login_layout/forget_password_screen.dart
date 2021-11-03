import 'package:email_validator/email_validator.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password request'),
        titleTextStyle:
            getTextTheme(context).headline2!.copyWith(color: WHITE_COLOR),
      ),
      backgroundColor: BLACK_COLOR,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildLogoImage(),
                    buildFieldColumn(context),
                    buildVerticalSpace(height: 10),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  buildFieldColumn(context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildDefaultTextField(
              enabledOutlineBorder: true,
              context: context,
              controller: _emailController,
              label: EMAIL_LABEL,
              type: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) if (value == null ||
                    value.isEmpty) return 'Email is required !';
                if (!EmailValidator.validate(value))
                  return 'Enter a real email, please !';
                return null;
              },
              focusedOutlineBorder: true),
          buildVerticalSpace(height: 40),
          buildDefaultBtn(
              onPressed: () async{
                if (_formKey.currentState!.validate()) {
                  await UserFirebase.resetPassword(_emailController.text);
                  _emailController.text = '';
                }
              },
              txt: 'Confirm',
              context: context),
        ],
      ),
    );
  }
}
