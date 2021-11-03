import 'package:enactus/models/feedback.dart' as MyFeedback;
import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/profile_screen/profile_edit/profile_edit_screen.dart';
import 'package:enactus/modules/profile_screen/profile_screen/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/fonts.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';

class ProfileScreen extends StatelessWidget {
  UserModel user = generalUser;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  double screenHeight = 0;
  double screenWidth = 0;
  late ProfileCubit cubit;
  TextEditingController _scoreController = TextEditingController();

  ProfileScreen({UserModel? user}) {
    if (user != null) this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = getScreenHeight(context);
    screenWidth = getScreenWidth(context);
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: BlocConsumer<ProfileCubit, ProfileStates>(
          listener: (_, __) => {},
          builder: (context, state) {
            cubit = ProfileCubit.get(context);
            return WillPopScope(
              onWillPop: () async {
                // if (user.uId != generalUser.uId)
                // Navigator.pop(context, user);
                return true;
              },
              child: Scaffold(
                key: scaffoldKey,
                body: NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                          iconTheme: IconThemeData(color: BLACK_COLOR),
                          backgroundColor: PRIMARY_SWATCH,
                          actions: [
                            user.id == generalUser.id
                                ? IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: BLACK_COLOR,
                                    ),
                                    onPressed: () {
                                      navigate(context, ProfileEditScreen());
                                    },
                                  )
                                : Container(),
                          ])
                    ];
                  },
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildProfileImageContainer(),
                        buildVerticalSpace(height: 10),
                        Text(
                          user.fullName,
                          style: getTextTheme(context)
                              .headline2!
                              .copyWith(fontSize: 22),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.authority == USER_AUTHORITY
                                  ? 'Member in ${user.teamName}'
                                  : user.position,
                              style: getTextTheme(context).bodyText1!.copyWith(
                                  fontFamily: REGULAR_FONT,
                                  color: PRIMARY_SWATCH,
                                  fontSize: FONT_10),
                            ),
                            buildHorizontalSpace(width: 5),
                            user.authority != USER_AUTHORITY
                                ? Image.asset(
                                    user.authority == HIGH_BOARD_AUTHORITY
                                        ? CHECK_ICON
                                        : user.authority == ON_BOARD_AUTHORITY
                                            ? BADGE_ICON
                                            : STAR_ICON,
                                    width: 12,
                                    height: 12,
                                  )
                                : Container(),
                          ],
                        ),
                        buildVerticalSpace(height: 30),
                        buildScoreAndRank(context, user.score.toString(),
                            user.rank.toString()),
                        buildVerticalSpace(height: 50),
                        buildFeedBacks(context)
                      ],
                    ),
                  ),
                ),
                floatingActionButton: user.id == generalUser.id
                    ? Container()
                    : FloatingActionButton(
                        backgroundColor: PRIMARY_SWATCH,
                        child: Icon(
                          Icons.edit,
                          color: WHITE_COLOR,
                        ),
                        onPressed: () {
                          cubit.openSheetOrNot()
                              ? scaffoldKey.currentState!
                                  .showBottomSheet((context) =>
                                      buildBottomSheet(context, state))
                                  .closed
                                  .then((value) => cubit.opened = false)
                              : Navigator.pop(context);
                        },
                      ),
              ),
            );
          }),
    );
  }

  buildBottomSheet(context, state) {
    return Container(
      height: screenHeight * 0.25,
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5), topRight: Radius.circular(5)),
        color: BLACK_COLOR,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          buildDefaultTextField(
              context: context,
              controller: _scoreController,
              label: 'Score',
              type: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) return 'This field is required';
                if (double.parse(value.toString()) < user.score)
                  return 'You can increase the score only!';
                return null;
              }),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
            child: state is ProfileUpdateScoreLoadingState
                ? CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : buildDefaultBtn(
                    onPressed: () async {
                      await cubit.updateScore(user, user.score,
                          double.parse(_scoreController.text));
                      Navigator.pop(context);
                    },
                    txt: 'Save',
                    context: context,
                    radius: 25),
          )
        ],
      ),
    );
  }

  buildProfileImageContainer() {
    return Container(
      height: 200,
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 120,
            color: PRIMARY_SWATCH,
          ),
          Align(
            child: buildCircleImage(user.image, MEDIUM_PHOTO_SIZE),
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  buildScoreAndRank(context, String score, String rank) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(
                'Score',
                style: getTextTheme(context).bodyText2,
              ),
              buildVerticalSpace(height: 10),
              Text(
                user.score.toString(),
                style: getTextTheme(context).headline2,
              ),
            ],
          ),
        ),
        Container(
          color: blackLightColor,
          width: 1,
          height: 50,
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Rank',
                style: getTextTheme(context).bodyText2,
              ),
              buildVerticalSpace(height: 10),
              Text(
                user.rank.toString(),
                style: getTextTheme(context).headline2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  buildFeedBacks(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Feedbacks:',
              style: getTextTheme(context).headline2!.copyWith(fontSize: 15),
            ),
            buildFeedbackListView(
                context, user.feedBacks..sort((f1, f2) => f1.compare(f2)))
          ],
        ),
      ),
    );
  }

  buildFeedbackListView(context, List<MyFeedback.Feedback> feedbacks) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) =>
              buildFeedBackItem(context, feedbacks[index]),
          itemCount: feedbacks.length,
        ));
  }

  buildFeedBackItem(context, MyFeedback.Feedback feedback) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: GREY_COLOR)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('Week ${feedback.week}',
                      style: getTextTheme(context)
                          .headline2!
                          .copyWith(color: PRIMARY_SWATCH)),
                  //buildHorizontalSpace(width: 13),
                  Spacer(),
                  feedback.by == "" || feedback.by == null
                      ? Container()
                      : Container(
                          color: PRIMARY_SWATCH.withOpacity(0.5),
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                          child: Text(
                            'by: ' + feedback.by!,
                            style: getTextTheme(context)
                                .headline2!
                                .copyWith(fontSize: 10),
                          ),
                        )
                ],
              ),
              buildVerticalSpace(height: 25),
              Text(
                feedback.message,
                style: getTextTheme(context).bodyText1,
              ),
              buildVerticalSpace(height: 10),
              buildFilesColumn(feedback)
            ],
          ),
        ),
      ),
    );
  }

  buildFilesColumn(MyFeedback.Feedback feedback) {
    return Column(
      children: feedback.files
          .map((file) => InkWell(
                onTap: () => viewWebPage(file.values.first),
                child: Container(
                  color: GREY_COLOR,
                  margin: EdgeInsets.symmetric(vertical: 5),
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Icon(Icons.insert_drive_file),
                      buildHorizontalSpace(width: 10),
                      Expanded(
                          child: Text(
                        file.keys.first,
                        style: TextStyle(fontSize: 14),
                      ))
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }
}
