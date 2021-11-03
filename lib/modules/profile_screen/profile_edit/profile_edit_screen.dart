
import 'package:enactus/modules/profile_screen/profile_edit/password_edit_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/fonts.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class ProfileEditScreen extends StatelessWidget {
  final TextEditingController _phoneController =
      TextEditingController(text: generalUser.phone);
  final TextEditingController _fullNameConroller =
      TextEditingController(text: generalUser.fullName);
  late EditCubit cubit;
  IconData cameraIcon = Icons.camera_alt_rounded;
  var formKey = GlobalKey<FormState>();
  bool failed = false;
  bool success = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EditCubit(),
      child: BlocConsumer<EditCubit, ProfileEditState>(
        listener: (_, state) {
          if (state is EditImagePickedSuccess)
            cameraIcon = Icons.close;
          else if (state is EditNoImagePicked)
            cameraIcon = Icons.camera_alt_rounded;

          if (state is EditFailedState && !failed) {
            showToast('Unknown problem, check your internet');
            failed = true;
          }  else if (state is EditPhotoSuccessState) {
            cameraIcon = Icons.camera_alt_rounded;
          }
        },
        builder: (context, state) {
          cubit = EditCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: BLACK_COLOR),
                backgroundColor: PRIMARY_SWATCH,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.save,
                      color: BLACK_COLOR,
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        if (state is EditImagePickedSuccess &&
                            cubit.profileImage != null)
                          await cubit.updateProfileImage(cubit.profileImage!);
                        if (_fullNameConroller.text != generalUser.fullName)
                          await cubit.updateName(_fullNameConroller.text);

                        if (_phoneController.text != generalUser.phone)
                          await cubit.updatePhone(_phoneController.text);
                      }
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildProfileImageContainer(state),
                      buildVerticalSpace(height: 10),
                      Text(
                        generalUser.fullName,
                        style: getTextTheme(context)
                            .headline2!
                            .copyWith(fontSize: 30),
                      ),
                      Text(
                        generalUser.email,
                        style: getTextTheme(context).caption!.copyWith(
                            fontFamily: BOLD_FONT, color: PRIMARY_SWATCH),
                      ),
                      createEditTextFields(context),
                      state is EditLoadingState
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: LinearProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    PRIMARY_SWATCH),
                                backgroundColor: GREY_COLOR,
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }

  createEditTextFields(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 100),
        child: Container(
          child: Column(
            children: [
              buildDefaultTextField(
                  context: context,
                  controller: _fullNameConroller,
                  label: 'Full name',
                  type: TextInputType.name,
                  focusedOutlineBorder: true,
                  focusBorderColor: BLACK_COLOR,
                  enabledOutlineBorder: true,
                  enabledBorderColor: BLACK_COLOR,
                  textColor: BLACK_COLOR,
                  validator: (value) {
                    if (value!.isEmpty) return 'Name is required';
                    return null;
                  }),
              buildVerticalSpace(height: 30),
              buildDefaultTextField(
                  context: context,
                  controller: _phoneController,
                  label: 'Phone number',
                  type: TextInputType.phone,
                  focusedOutlineBorder: true,
                  focusBorderColor: BLACK_COLOR,
                  enabledOutlineBorder: true,
                  enabledBorderColor: BLACK_COLOR,
                  textColor: BLACK_COLOR,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Phone is required !';
                    if (value.length != 11) return 'Invalid phone !';
                    String firstPart = value.substring(0, 3);
                    if ((firstPart != '010' &&
                        firstPart != '011' &&
                        firstPart != '012' &&
                        firstPart != '015')) return 'Invalid phone !';
                    return null;
                  }),
              buildVerticalSpace(height: 50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: buildDefaultBtn(
                    onPressed: () {
                      navigate(context, ChangePasswordScreen());
                    },
                    txt: 'Change password',
                    radius: 25,
                    context: context),
              )
            ],
          ),
        ),
      ),
    );
  }

  buildProfileImageContainer(state) {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 120,
              color: PRIMARY_SWATCH,
            ),
          ),
          InkWell(
            onTap: () {
              cubit.takeImageFromGallery();
            },
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                buildCircleImage(generalUser.image, MEDIUM_PHOTO_SIZE,
                    pickedImage: cubit.profileImage!= null && state is EditLoadingState?
                         FileImage(cubit.profileImage!)
                        : null),
                Positioned(
                    bottom: 15,
                    child: InkWell(
                        onTap: () {
                          if (state is EditImagePickedSuccess)
                            cubit.closePickedImage();
                          else
                            cubit.takeImageFromGallery();
                        },
                        child: CircleAvatar(child: Icon(cameraIcon)))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
