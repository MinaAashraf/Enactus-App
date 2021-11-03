import 'dart:io';

import 'package:enactus/modules/post_creation/cubit/cubit.dart';
import 'package:enactus/modules/post_creation/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:enactus/shared/styles/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostCreation extends StatelessWidget {
  TextEditingController _postController = TextEditingController();
  late PostCreationCubit cubit;
  final int postOrder;

  PostCreation({required this.postOrder});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => PostCreationCubit(postOrder),
      child: BlocConsumer<PostCreationCubit, PostCreationStates>(
        listener: (context, state) {
          if (state is PostCreatedSuccessState) {
            showToast('Done !');
            Navigator.pop(context);
          }
          if (state is PostCreatedFailedState)
            showToast('Check your internet !');
        },
        builder: (BuildContext context, state) {
          cubit = PostCreationCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              actions: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                  child: cubit.onPostPressed != null
                      ? buildDefaultBtn(
                          onPressed: cubit.onPostPressed,
                          txt: 'Post',
                          context: context,
                          radius: 0,
                          width: 40,
                          textStyle: getTextTheme(context)
                              .bodyText1!
                              .copyWith(color: WHITE_COLOR, fontSize: 13),
                          fontSize: FONT_14)
                      : buildDefaultBtn(
                          onPressed: null,
                          txt: 'Post',
                          context: context,
                          textStyle: getTextTheme(context)
                              .bodyText1!
                              .copyWith(fontSize: 13),
                          radius: 0,
                          width: 40,
                          fontSize: FONT_14),
                ),
              ],
            ),
            body: Column(
              children: [
                state is PostCreateLoadingState
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: LinearProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              PRIMARY_SWATCH),
                          backgroundColor: GREY_COLOR,
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: createPostTextField(context),
                ),
                Spacer(),
                cubit.postImage != null
                    ? buildImage(cubit.postImage!)
                    : Container(),
                buildVerticalSpace(),
                createPhotoButton(context),
              ],
            ),
          );
        },
      ),
    );
  }

  createPostTextField(context) {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'What\'s in your mind ?',
          hintStyle: getTextTheme(context).bodyText2),
      controller: _postController,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      style: getTextTheme(context)
          .bodyText2!
          .copyWith(height: 1.35, fontSize: FONT_10),
      onChanged: (value) {
        cubit.setPostButtonOnPressed(value);
      },
    );
  }

  createPhotoButton(context) {
    return buildDefaultBtn(
        onPressed: () async {
          await cubit.takeImageFromGallery();
          cubit.setPostButtonOnPressed(_postController.text);
        },
        txt: 'Upload a photo',
        context: context);
  }

  Widget buildImage(File? image) {
    return Stack(alignment: Alignment.topRight, children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Container(
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(image: FileImage(image!), fit: BoxFit.cover)),
        ),
      ),
      Positioned(
        top: 0,
        right: 8,
        child: InkWell(
            onTap: () {
              cubit.closeImage(_postController.text);
            },
            child: CircleAvatar(
                radius: 20,
                child: Icon(
                  Icons.close,
                  size: 20,
                ))),
      )
    ]);
  }
}
