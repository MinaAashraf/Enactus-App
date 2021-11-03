import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  var formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change password'),
        iconTheme: IconThemeData(color: BLACK_COLOR),
        backgroundColor: PRIMARY_SWATCH,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  buildLogoImage(),
                  buildVerticalSpace(height: 40),
                  createEditTextFields(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  buildLogoImage() {
    return Align(
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Image(
            image: AssetImage('$GREY_LOGO'),
          ),
        ),
      ),
    );
  }

  TextEditingController _currentPasswordController = TextEditingController(),
      _newPasswordController = TextEditingController();

  createEditTextFields(context) {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        children: [
          buildDefaultTextField(
              context: context,
              controller: _currentPasswordController,
              label: 'Current password',
              type: TextInputType.visiblePassword,
              focusedOutlineBorder: true,
              isSecure: true,
              focusBorderColor: BLACK_COLOR,
              enabledOutlineBorder: true,
              enabledBorderColor: BLACK_COLOR,
              textColor: BLACK_COLOR,
              validator: (value) {
                if (value!.isEmpty)
                  return 'This field is required';
                return null;
              }),
          buildVerticalSpace(height: 30),
          buildDefaultTextField(
              context: context,
              controller: _newPasswordController,
              label: 'New password',
              type: TextInputType.visiblePassword,
              isSecure: true,
              focusedOutlineBorder: true,
              focusBorderColor: BLACK_COLOR,
              enabledOutlineBorder: true,
              enabledBorderColor: BLACK_COLOR,
              textColor: BLACK_COLOR,
              validator: (value) {
                if (value!.isEmpty)
                  return 'This field is required';
                else if (value.length < 8)
                  return 'This password is very weak';
                return null;
              }),
          buildVerticalSpace(height: 50),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 35),
            child: loading ? CircularProgressIndicator(strokeWidth: 1.5):
            buildDefaultBtn(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      loading = true;
                    });
                    await UserFirebase.changePassword(
                        _currentPasswordController.text , _newPasswordController.text);
                    setState(() {
                      loading = false;
                    });
                    _currentPasswordController.text = '';
                    _newPasswordController.text = '';
                  }
                },
                txt: 'Confirm',
                radius: 25,
                context: context),
          )
        ],
      ),
    );
  }
}
