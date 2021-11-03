import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/profile_screen/profile_screen/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  ProfileCubit() : super(ProfileInitState());

  static ProfileCubit get(context) => BlocProvider.of(context);

  updateScore(
      UserModel userWhoseChangedScore, double oldScore, double newScore) async {
    emit(ProfileUpdateScoreLoadingState());
    try {
      await _updateRank(userWhoseChangedScore, newScore);
    } catch (err) {}
  }

  Future<void> _updateRank(
      UserModel userWhoseChangedScore, double newScore) async {
    try {
      int newRank = userWhoseChangedScore.rank;
      QuerySnapshot<Map<String, dynamic>> qSnapShot =
          await _getUsersWithProperRankRange(userWhoseChangedScore, newScore);
      await UserFirebase.updateAnotherUserField(
          'score', newScore, userWhoseChangedScore.uId);
      int counter = 0;
      Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> usersInMyTeam =
          qSnapShot.docs.where((doc) =>
              doc.data()[TEAM_Name_FIELD] == userWhoseChangedScore.teamName);

      usersInMyTeam.forEach((snapShot) async {
        UserModel userModel = UserModel.fromJson(snapShot.data());
        if (userModel.score == userWhoseChangedScore.score &&
            userModel.uId != userWhoseChangedScore.uId) {
          await snapShot.reference.update({'rank': userModel.rank + 1});
          if (newRank > userModel.rank) newRank = userModel.rank;
        } else if (userModel.score != newScore &&
            userModel.uId != userWhoseChangedScore.uId) {
          newRank = userModel.rank;
          await snapShot.reference.update({'rank': newRank + 1});
        } else if (userModel.score == newScore) {
          newRank = userModel.rank;
        }

        counter++;
        if (counter == usersInMyTeam.length) {
          await UserFirebase.updateAnotherUserField(
              'rank', newRank, userWhoseChangedScore.uId);
          userWhoseChangedScore.score = newScore;
          userWhoseChangedScore.rank = newRank;
          emit(ProfileUpdateScoreState());
        }
      });
      if (counter == 0) {
        userWhoseChangedScore.score = newScore;
        emit(ProfileUpdateScoreState());
      }
    } catch (err) {}
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getUsersWithProperRankRange(
      UserModel userWhoseChangedScore, double newScore) async {
    return await UserFirebase.getUsersWithProperRankRange(
        userWhoseChangedScore.uId,
        userWhoseChangedScore.teamName,
        userWhoseChangedScore.score,
        newScore);
  }

  bool opened = false;

  bool openSheetOrNot() {
    opened = !opened;
    return opened;
  }
}
