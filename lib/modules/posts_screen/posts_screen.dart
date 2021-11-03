import 'package:enactus/models/post/post.dart';
import 'package:enactus/modules/posts_screen/cubit/cubit.dart';
import 'package:enactus/modules/posts_screen/cubit/states.dart';
import 'package:enactus/modules/post_creation/post_creation.dart';
import 'package:enactus/modules/posts_screen/likers/likers_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class PostScreen extends StatefulWidget {
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  late PostsCubit cubit;

  @override
  void dispose() {
    cubit.cancelListener();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PostsCubit, PostStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        cubit = PostsCubit.get(context);
        return Scaffold(
            backgroundColor: GREY_COLOR,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  postCreationOpacity(generalUser.authority)
                      ? buildContainerOfPostCreation(context)
                      : buildVerticalSpace(height: 5),
                  state is! PostsReadLoading
                      ? buildPostListView(context)
                      : Padding(
                          padding: EdgeInsets.only(
                              top: getScreenHeight(context) / 4),
                          child: Center(
                              child: CircularProgressIndicator(
                            strokeWidth: 2,
                          )),
                        )
                ],
              ),
            ));
      },
    );
  }

  buildPostListView(context) {
    return cubit.posts.isNotEmpty
        ? MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildPostItem(context, index, cubit.posts[index]),
                itemCount: cubit.posts.length),
          )
        : Padding(
            padding: EdgeInsets.only(top: getScreenHeight(context) / 4),
            child: Center(
              child: Image.asset(
                EMPTY_IMAGE,
                width: 100,
                height: 100,
              ),
            ),
          );
  }

  buildContainerOfPostCreation(context) {
    return Card(
        margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
        child: buildImageAndPostButtonRow(context));
  }

  buildImageAndPostButtonRow(context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          buildCircleImage(generalUser.image, SMALL_PHOTO_SIZE),
          buildHorizontalSpace(width: 10),
          buildRoundedPostButton(context),
        ],
      ),
    );
  }

  buildRoundedPostButton(context) {
    return Expanded(
      child: Container(
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.fromBorderSide(BorderSide(color: PRIMARY_SWATCH))),
        child: MaterialButton(
          onPressed: () {
            navigate(context, PostCreation(postOrder: cubit.posts.length));
          },
          child: Text('What\'s in your mind ?'),
          elevation: 0,
        ),
      ),
    );
  }

  buildPostItem(context, int index, Post post) {
    return Card(
      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, right: 15, left: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildCircleImageWithTitlesColum(
                post.creatorId,
                post.creatorImage,
                post.creatorName,
                post.creatorAuthority,
                post.handlePostDate(),
                context,
                index),
            buildPostText(post.text, context),
            buildImage(post.postImage),
            buildLikeAndCommentNumbersRow(
                context, post.likesCount, post.commentsNum, index),
            buildDividerView(height: 0.4, padding: 0),
            buildLikeAndCommentRow(context, post, index)
          ],
        ),
      ),
    );
  }

  buildLikeAndCommentRow(context, Post post, int index) {
    return Row(
      children: [
        TextButton(
          onPressed: () {
            cubit.likePost(postIndex: index, currentLikeCount: post.likesCount);
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                LIKE_ICON,
                width: 20,
                height: 20,
                color: (index < cubit.posts.length && cubit.isLiked(index))
                    ? PRIMARY_SWATCH
                    : blackLightColor,
              ),
              buildHorizontalSpace(width: 5),
              Text(
                'Like',
                style: getTextTheme(context)
                    .bodyText2!
                    .copyWith(fontSize: FONT_10, color: blackLightColor),
              )
            ],
          ),
        ),
/*        Spacer(),
        InkWell(
          onTap: () {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: SvgPicture.asset(
                  COMMENT_ICON,
                  width: 20,
                  height: 20,
                  color: blackLightColor,
                ),
              ),
              buildHorizontalSpace(width: 5),
              Text(
                'Comment',
                style: getTextTheme(context)
                    .bodyText2!
                    .copyWith(fontSize: FONT_10, color: blackLightColor),
              )
            ],
          ),
        ),*/
      ],
    );
  }

  buildLikeAndCommentNumbersRow(context, int likes, int comments, postIndex) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            if (likes != 0)
              navigate(
                  context,
                  LikersScreen(
                      cubit.postsUsersLikes[cubit.posts[postIndex].postId]));
          },
          child: Text(
            '$likes likes',
            style: getTextTheme(context).bodyText2!.copyWith(fontSize: FONT_10),
          ),
        ),

        /* Spacer(),
        Text(
          '$comments Comments',
          style: getTextTheme(context).bodyText2!.copyWith(fontSize: FONT_10),
        ),*/
      ],
    );
  }

  buildCircleImageWithTitlesColum(
      String creatorId,
      String creatorImage,
      String creatorName,
      String creatorAuthority,
      String postTime,
      BuildContext context,
      int postIndex) {
    return Row(
      children: [
        InkWell(
            onTap: () {
              cubit.onProfileClick(context, creatorId);
            },
            child: buildCircleImage(creatorImage, SMALL_PHOTO_SIZE)),
        buildHorizontalSpace(width: 10),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      cubit.onProfileClick(context, creatorId);
                    },
                    child: Text(
                      creatorName,
                      style: getTextTheme(context)
                          .headline2!
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  buildHorizontalSpace(width: 5),
                  Image.asset(
                    creatorAuthority == HIGH_BOARD_AUTHORITY
                        ? CHECK_ICON
                        : creatorAuthority == ON_BOARD_AUTHORITY
                            ? BADGE_ICON
                            : STAR_ICON,
                    width: 12,
                    height: 12,
                  ),
                ],
              ),
              Text(
                postTime,
                style: getTextTheme(context).caption,
              ),
            ],
          ),
        ),
       cubit.getRemoveIconOpacity(postIndex)? IconButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => buildWarningDialog(postIndex));
            },
            icon: Icon(
              Icons.delete,
              size: 20,
              color: Colors.black,
            )) : Container()
      ],
    );
  }

  buildWarningDialog(int index) {
    return AlertDialog(
      title: Text('Warning', style: getTextTheme(context).headline2),
      // To display the title it is optional
      content: Text('Are you sure you want to remove the post?',
          style: getTextTheme(context).bodyText2!.copyWith(fontSize: 12)),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: getTextTheme(context).button,
              ),
            ),
            TextButton(
              onPressed: () {
                cubit.removePost(index);
                Navigator.of(context).pop();
              },
              child: Text('Remove', style: getTextTheme(context).button),
            )
          ],
        ),
      ],
    );
  }

  buildPostText(String txt, context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 10),
      child: Text(
        txt,
        style: getTextTheme(context)
            .bodyText2!
            .copyWith(height: 1.35, fontSize: FONT_10),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget buildImage(String? image) {
    return image != null
        ? Image.network(
            image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: 250,
          )
        : Container(width: 0, height: 0);
  }

  bool postCreationOpacity(String authority) {
    return authority == USER_AUTHORITY ? false : true;
  }
}
