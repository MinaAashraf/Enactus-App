import 'package:enactus/models/user/user.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class MembersScreen extends StatelessWidget {
  final String teamName;

  final String myFullName;

  MembersScreen({required this.teamName, required this.myFullName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
          MemberCubit()..getMembers(teamName: teamName, myFullName: myFullName),
      child: BlocConsumer<MemberCubit, MembersStates>(
        listener: (_, __) => {},
        builder: (context, state) {
          MemberCubit cubit = MemberCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                teamName,
                style: getTextTheme(context)
                    .headline2!
                    .copyWith(color: PRIMARY_SWATCH),
              ),
              titleSpacing: 40,
            ),
            body: createMembersList(state, cubit),
            floatingActionButton: Opacity(
              opacity: cubit.checked.where((element) => element == 1).isNotEmpty
                  ? 1
                  : 0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pop(context,cubit.selectedMembers);
                },
                backgroundColor: BLACK_COLOR,
                elevation: 0,
                child: Icon(
                  Icons.check,
                  color: PRIMARY_SWATCH,
                  size: 28,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  createMembersList(MembersStates state, MemberCubit cubit) {
    return state is! MembersLoadingState
        ? Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView.separated(
              itemBuilder: (context, index) {
                UserModel member = cubit.members[index];
                return InkWell(
                    onTap: () {
                      cubit.onItemPressed(index);
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: buildCircleImageWithTitle(
                                member.image, member.fullName, context)),
                        Opacity(
                            opacity: cubit.checked[index],
                            child: Icon(
                              Icons.check,
                              color: PRIMARY_SWATCH,
                              size: 28,
                            ))
                      ],
                    ));
              },
              itemCount: cubit.members.length,
              separatorBuilder: (BuildContext context, int index) =>
                  buildVerticalSpace(),
            ),
          )
        : Center(child: CircularProgressIndicator());
  }
}
