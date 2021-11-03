import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/posts_screen/likers/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikersCubit extends Cubit<LikersStates> {
  LikersCubit() : super(LikersInitialState());

  static LikersCubit get(context) => BlocProvider.of(context);
  List<UserModel> likers = [];

  getLikers(List<String>? likersIds) async {
    emit(LikersLoadingState());
    try  {
    QuerySnapshot<Map<String, dynamic>> query= await UserFirebase.getSomeUsers(likersIds!);
    query.docs.forEach((doc) {
       likers.add(UserModel.fromJson(doc.data()));
       emit(LikersSuccessState());
    });
    } catch (err) {
      emit(LikersFailedState());
    }
  }
}
