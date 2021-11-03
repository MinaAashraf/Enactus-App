import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/feedback_screen/members_screen/cubit/cubit.dart';
import 'package:enactus/modules/feedback_screen/members_screen/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamMembersScreen extends StatelessWidget {
 late MemberCubit cubit ;
 final String teamName;

 TeamMembersScreen({required this.teamName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>
      MemberCubit()..getMembers(teamName: teamName),
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
              titleSpacing: 0,
            ),
            body:

            createMembersList(state, cubit),

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
              onTap: ()async {
                 cubit.onProfileClick(index,context);
              },
              child: Row(
                children: [
                  Expanded(
                      child: buildCircleImageWithTitle(
                          member.image, member.fullName, context)),
                ],
              ));
        },
        itemCount: cubit.members.length,
        separatorBuilder: (BuildContext context, int index) =>
            buildVerticalSpace(),
      ),
    )
        : Center(child: CircularProgressIndicator(strokeWidth: 2,));
  }

}
