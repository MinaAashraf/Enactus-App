import 'package:enactus/layouts/home_layout/cubit/cubit.dart';
import 'package:enactus/layouts/home_layout/cubit/states.dart';
import 'package:enactus/layouts/home_layout/home_layout.dart';
import 'package:enactus/models/notification.dart';
import 'package:enactus/modules/posts_screen/posts_screen.dart';
import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:enactus/models/notification.dart' as MyNotification;
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MyNotification.Notification> notifications =
        generalUser.notifications.reversed.toList();
    final screenHeight = getScreenHeight(context);
    final screenWidth = getScreenWidth(context);
    UserFirebase.clearUnSeenNotificationsNumber();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: notifications.isNotEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: getTextTheme(context).headline1,
                ),
                Expanded(
                    child: ListView.separated(
                  itemCount: notifications.length,
                  itemBuilder: (_, index) =>
                      buildNotificationItem(notifications[index], context),
                  separatorBuilder: (BuildContext context, int index) =>
                      buildDividerView(),
                ))
              ],
            )
          : Center(
              child: Image.asset(
              EMPTY_NOTIFICATION_IMAGE,
              width: screenHeight / 3,
              height: screenWidth / 3,
            )),
    );
  }

  buildNotificationItem(MyNotification.Notification notification, context) {
    return buildCircleImageWithTitlesColum(notification.url, notification.title,
        notification.handleNotiDate(), context);
  }

  buildCircleImageWithTitlesColum(String? image, String title,
      String notificationTime, BuildContext context) {
    return InkWell(
      onTap: () {
        title.contains('feedback')
            ? navigate(context, ProfileScreen())
            : navigateAndFinish(context, HomeLayout());
      },
      child: Row(
        children: [
          buildCircleImage(image, SMALL_PHOTO_SIZE + 5,
              anonymousImage: image == null),
          buildHorizontalSpace(width: 10),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      getTextTheme(context).headline2!.copyWith(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  notificationTime,
                  style: getTextTheme(context).caption,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
