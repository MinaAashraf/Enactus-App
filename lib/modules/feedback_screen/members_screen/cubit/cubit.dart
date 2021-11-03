
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/models/user_name_and_id.dart';
import 'package:enactus/modules/feedback_screen/members_screen/cubit/states.dart';
import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MemberCubit extends Cubit<MembersStates> {
  MemberCubit() : super(MembersInitState());

  static MemberCubit get(context) => BlocProvider.of(context);

  List<UserModel> members = [];
  List<String> uIds = [];
  List<double> checked = [];

  getMembers({required String teamName, String myFullName = ''}) async {
    emit(MembersLoadingState());
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapShop =
          await UserFirebase.getMembers(teamName);

      querySnapShop.docs.forEach((docSnapShot) {
        UserModel member = UserModel.fromJson(docSnapShot.data());
        members.add(member);
        if (myFullName.isNotEmpty) {
          if (member.authority == generalUser.authority)
            members.removeLast();
          else {
            checked.add(0);
            uIds.add(docSnapShot.id);
          }
        }
      });

      emit(MembersReadSuccessState());
    } catch (err) {
      emit(MembersReadFailedState());
    }
  }

  List<UserNameAndId> selectedMembers = [];

  onItemPressed(int index) {
    if (checked[index] == 0) {
      selectedMembers.add(UserNameAndId(members[index], uIds[index]));
      checked[index] = 1;
    } else {
      selectedMembers.removeAt(index);
      checked[index] = 0;
    }

    emit(MemberOnSelectedState());
  }

  UserModel? user;

  onProfileClick(index, context) async {
  //  if (user != null && user!.uId == members[index].uId) members[index] = user!;
    String myAuthority = generalUser.authority;
    UserModel member = members[index];
    if (myAuthority == HIGH_BOARD_AUTHORITY ||
        (myAuthority == ON_BOARD_AUTHORITY &&
            member.teamName == generalUser.teamName) ||
        (myAuthority == HR_AUTHORITY &&
            member.teamName == generalUser.teamName &&
            member.authority != ON_BOARD_AUTHORITY))
      user = await navigate(
          context,
          ProfileScreen(
            user: member,
          ));
  }
}
