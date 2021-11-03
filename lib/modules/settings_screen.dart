import 'package:enactus/layouts/login_layout/login_layout.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/modules/teams_screen/teams_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about_screen.dart';

class SettingScreen extends StatelessWidget {

  double screenHeight = 0.0;

  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    UserModel user = generalUser;
    screenHeight = getScreenHeight(context);
    screenWidth = getScreenWidth(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenWidth / 20,
                right: screenWidth / 20,
                left: screenWidth / 20),
            child: buildImageWithNameRow(
                user.image,
                user.fullName,
                context),
          ),
          buildDividerView(),
          buildVerticalSpace(height: screenHeight / 25),
          buildSettingButtonsColumn(context),
          buildVerticalSpace(height: screenHeight / 20),
          Padding(
            padding: EdgeInsets.only(
                bottom: 15, left: screenWidth / 5, right: screenWidth / 5),
            child: buildDefaultBtn(
                onPressed: () {
                  UserFirebase.signOut();
                  navigateAndFinish(context, LoginLayout());
                },
                txt: 'Log out',
                context: context,
                radius: 22),
          )
        ],
      ),
    );
  }

  buildImageWithNameRow(String imageUrl, String userName,
      BuildContext context) {
    return InkWell(
      onTap: () => navigate(context, ProfileScreen()),
      child: Row(
        children: [
          buildCircleImage(imageUrl, SMALL_PHOTO_SIZE),
          buildHorizontalSpace(width: screenWidth/30),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style:
                getTextTheme(context).headline2!.copyWith(fontSize: FONT_14),
              ),
              Text(
                'See your profile',
                style:
                getTextTheme(context).bodyText2!.copyWith(fontSize: FONT_9),
              ),
            ],
          )
        ],
      ),
    );
  }

  buildSettingButtonsColumn(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth / 20),
      child: Column(
        children: [
          buildSettingButton(
              onPressed: () {
                navigate(context, AboutScreen());
              },
              txt: ABOUT_US,
              context: context,
              svgImageAsset: ABOUT_ICON),
          buildVerticalSpace(),

          buildSettingButton(
              onPressed: () {
                navigate(context, TeamsScreen());
              },
              txt: TEAMS,
              context: context,
              svgImageAsset: TEAMS_ICON),
          buildVerticalSpace(),

          buildSettingButton(
              onPressed: () {
                viewWebPage(FACEBOOK_PAGE);
              },
              txt: 'Facebook',
              context: context,
              svgImageAsset: FACEBOOK_ICON),
          buildVerticalSpace(),

          buildSettingButton(
              onPressed: () {
                viewWebPage(INSTAGRAM_PAGE);
              },
              txt: 'Instagram',
              context: context,
              svgImageAsset: INSTAGRAM_ICON),
          buildVerticalSpace(),
        ],
      ),
    );
  }

  buildSettingButton({required String txt,
    required String svgImageAsset,
    required void Function() onPressed,
    required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
          color: WHITE30, borderRadius: BorderRadius.circular(15)),
      child: MaterialButton(
          minWidth: double.infinity,
          height: 75,
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Row(
              children: [
                SvgPicture.asset(
                  svgImageAsset,
                  width: SVG_ICON_SIZE,
                  height: SVG_ICON_SIZE,
                ),
                buildHorizontalSpace(),
                Hero(
                  tag: txt,
                  child: Text(
                    txt,
                    style: getTextTheme(context).bodyText1,
                  ),
                ),
              ],
            ),
          )),
    );
  }




}






