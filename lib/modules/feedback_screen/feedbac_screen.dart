import 'dart:math';

import 'package:enactus/models/user_name_and_id.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'members_screen/members_screen.dart';

class FeedbackScreen extends StatelessWidget {
  late FeedbackCubit cubit;

  final TextEditingController _weekController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FeedbackCubit(),
      child: BlocConsumer<FeedbackCubit, FeedbackStates>(
        listener: (context, state) {
          if (state is FeedbackOnSendSuccess) {
            showToast('Done');
            _weekController.text = '';
            _messageController.text = '';
          } else if (state is FeedbackOnSendFailed) showToast(state.err);
        },
        builder: (context, state) {
          screenHeight = getScreenHeight(context);
          screenWidth = getScreenWidth(context);
          cubit = FeedbackCubit.get(context);
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    createLinearProgressBar (state),
                    createHeadRow(context),
                    buildVerticalSpace(height: screenHeight / 20),
                    createToRow(context),
                    buildVerticalSpace(height: screenHeight / 20),
                    createWeakRow(context),
                    buildVerticalSpace(height: screenHeight / 20),
                    createMessageTextField(context),
                    buildVerticalSpace(height: screenHeight / 20),
                    cubit.localPaths != null && cubit.localPaths!.isNotEmpty
                        ? createFilesNamesViews()
                        : Container(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  createLinearProgressBar (state)
  {
   return state is FeedbackOnLoadingSuccess
        ? Padding(
      padding: const EdgeInsets.all(15.0),
      child: LinearProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(
            PRIMARY_SWATCH),
        backgroundColor: GREY_COLOR,
      ),
    )
        : Container();
  }

  createHeadRow(context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Feedback',
            style: getTextTheme(context).headline1,
          ),
        ),
        Transform.rotate(
          angle: 90 * pi/180,
          child: IconButton(
            icon: Icon(
              Icons.attach_file,
              color: PRIMARY_SWATCH,
              size: 30,

            ),
            onPressed: () {
              cubit.attachFiles();
            },
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.send,
            color: PRIMARY_SWATCH,
            size: 30,
          ),
          onPressed: () {
            if (_formKey.currentState!.validate())
              cubit.sendFeedback(
                  int.parse(_weekController.text), _messageController.text);
          },
        ),
      ],
    );
  }

  createFilesNamesViews() {
    return Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: GREY_COLOR)),
      child: Row(
        children: [
          Expanded(child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(children: getFilesNames()),
          )),


        ],
      ),
    );
  }

  getFilesNames() {
    return cubit.localPaths!
        .map(
          (path) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: PRIMARY_SWATCH),
                alignment: AlignmentDirectional.bottomStart,
                padding: const EdgeInsets.all(2.0),
                child: Row(
                  children: [
                    buildHorizontalSpace(width: 10),
                    Icon(
                      Icons.insert_drive_file,
                      color: BLACK_COLOR,
                      size: 20,
                    ),
                    buildHorizontalSpace(width: 10),
                    Text(path),
                    Spacer(),
                    IconButton(
                      padding: EdgeInsets.all(10),
                      onPressed: (){cubit.removeFile(cubit.localPaths!.indexOf(path));},
                      icon: CircleAvatar(
                        child: Icon(
                          Icons.close,
                          color: WHITE_COLOR,
                          size: 13,
                        ),
                        radius: 10,
                        backgroundColor: BLACK_COLOR,
                      ),
                    ),
                  ],
                ),
              )),
        )
        .toList();
  }

  createToRow(context) {
    return InkWell(
      onTap: () async {
        cubit.getMembers((await navigate(
            context,
            MembersScreen(
              teamName: generalUser.teamName,
              myFullName: generalUser.fullName,
            ))) as List<UserNameAndId>);
      },
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'To',
                  style: getTextTheme(context)
                      .bodyText2!
                      .copyWith(color: PRIMARY_SWATCH),
                ),
                buildHorizontalSpace(width: 10),
                Expanded(
                    child: Text(
                  cubit.members.length == 0
                      ? 'Choose user'
                      : cubit.writeSeparatedMembersNames(),
                  style: getTextTheme(context).bodyText2!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
              ],
            ),
            buildDividerView()
          ],
        ),
      ),
    );
  }

  createWeakRow(context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'Week',
                style: getTextTheme(context)
                    .bodyText2!
                    .copyWith(color: PRIMARY_SWATCH),
              ),
              buildHorizontalSpace(width: 10),
              Expanded(
                  child: TextFormField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Week number',
                ),
                controller: _weekController,
                keyboardType: TextInputType.number,
                style: getTextTheme(context).bodyText2,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter week number !';
                  return null;
                },
              ))
            ],
          ),
          buildDividerView(padding: 5),
        ],
      ),
    );
  }

  createMessageTextField(context) {
    return TextFormField(
      decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          hintText: 'Message here',
          hintStyle: getTextTheme(context).bodyText2!.copyWith(
                color: PRIMARY_SWATCH,
              )),
      controller: _messageController,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      style: getTextTheme(context).bodyText2,
      validator: (value) {
        if (value!.isEmpty) return 'Enter your message !';
        return null;
      },
    );
  }
}
