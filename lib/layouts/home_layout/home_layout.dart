import 'package:enactus/modules/feedback_screen/feedbac_screen.dart';
import 'package:enactus/modules/notification_screen.dart';
import 'package:enactus/modules/posts_screen/cubit/cubit.dart';
import 'package:enactus/modules/posts_screen/posts_screen.dart';
import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/modules/settings_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatelessWidget {
  late HomeCubit cubit;
  static bool abbBarShow = true;
  static late DefaultTabController tabsController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeCubit()..getUserData(),
        ),
        BlocProvider(
          create: (context) => PostsCubit()..getPosts(),
        )
      ],
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) => {},
        builder: (context, state) {
          cubit = HomeCubit.get(context);
          tabsController = DefaultTabController(
              length: 4,
              child: Scaffold(
                body: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return <Widget>[
                        SliverAppBar(
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Hero(
                              tag: '$LOGO',
                              child: buildSmallLogo(
                                  imageAssetName: FULL_COLOR_LOGO),
                            ),
                          ),
                          leadingWidth: 85,
                          actions: [
                            Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: IconButton(
                                  onPressed: () {
                                    navigate(context, ProfileScreen());
                                  },
                                  icon: buildCircleImage(
                                      cubit.user.image, VERY_SMALL_PHOTO_SIZE),
                                ))
                          ],
                          floating: true,
                          pinned: true,
                          bottom: TabBar(
                            padding: EdgeInsets.symmetric(vertical: 0),
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SvgPicture.asset(
                                  HOME_ICON,
                                  color: WHITE_COLOR,
                                  width: 28,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SvgPicture.asset(
                                  FEEDBACK_ICON,
                                  color: WHITE_COLOR,
                                  width: 28,
                                  height: 24,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Container(
                                  width: 28,
                                  height: 24,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    children: [
                                      SvgPicture.asset(
                                        NOTIFICATION_ICON,
                                        color: WHITE_COLOR,
                                        width: 28,
                                        height: 24,
                                      ),
                                      cubit.notificationsNum > 0
                                          ? Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                radius: 8,
                                                child: Text(
                                                  cubit.notificationsNum
                                                      .toString(),
                                                  style: getTextTheme(context)
                                                      .headline2!
                                                      .copyWith(
                                                          color: WHITE_COLOR,
                                                          fontSize: 10),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 0,
                                              width: 0,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SvgPicture.asset(
                                  MENU_ICON,
                                  color: WHITE_COLOR,
                                  width: 28,
                                  height: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        PostScreen(),
                        FeedbackScreen(),
                        NotificationScreen(),
                        SettingScreen()
                      ],
                    )),
              ));
          return tabsController;
        },
      ),
    );
  }
}
