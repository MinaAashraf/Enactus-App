import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/posts_screen/likers/cubit/cubit.dart';
import 'package:enactus/modules/posts_screen/likers/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LikersScreen extends StatelessWidget {
  final List<String>? LikersIds;

  LikersScreen(this.LikersIds);

  late LikersCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LikersCubit()..getLikers(LikersIds),
      child: BlocConsumer<LikersCubit, LikersStates>(
          listener: (_, __) => {},
          builder: (context, state) {
            cubit = LikersCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: PRIMARY_SWATCH,
                title: Text(
                  'Likes',
                  style: getTextTheme(context).headline2,
                ),
              ),
              body: state is LikersLoadingState
                  ? Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2 ,
                      ),
                  )
                  : createLikersList(),
            );
          }),
    );
  }

  createLikersList() {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) =>
              buildVerticalSpace(),
          itemBuilder: (context, index) =>
              buildCircleImageWithTitle(cubit.likers[index], context),
          itemCount: cubit.likers.length),
    );
  }

  buildCircleImageWithTitle(UserModel user, BuildContext context) {
    return Row(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            buildCircleImage(user.image, SMALL_PHOTO_SIZE+5),
            CircleAvatar(
              radius: 8,
                child: SvgPicture.asset(
              LIKE_ICON,
              color: BLACK_COLOR,
                  width: 10,
                  height: 10,
            ))
          ],
        ),
        buildHorizontalSpace(width: 15),
        Expanded(
          child: Text(
            user.fullName,
            style: getTextTheme(context).headline2!.copyWith(fontSize: 15),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        )
      ],
    );
  }
}
