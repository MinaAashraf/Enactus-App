import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/post/post.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/modules/posts_screen/cubit/states.dart';
import 'package:enactus/modules/profile_screen/profile_screen/profile_screen.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/post_firebase.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsCubit extends Cubit<PostStates> {
  PostsCubit() : super(PostsInitState());

  static PostsCubit get(context) => BlocProvider.of(context);

  List<Post> posts = [];
  Map<String, List<String>> postsUsersLikes = {};
  Map<String, bool> postsMyLikes = {};
  late StreamSubscription<QuerySnapshot> subscription;

  getPosts() async {
    try {
      emit(PostsReadLoading());
      subscription = PostFirebase.getPosts().listen((event) async {
        if (event.docChanges.isEmpty) emit(PostsOnReadSuccess());
        event.docChanges.forEach((docChange) async {
          DocumentSnapshot<Map<String, dynamic>> docSnapShot = docChange.doc;
          switch (docChange.type) {
            case DocumentChangeType.added:
              await getLikers(docSnapShot, added: true);
              Post post = cookPost(docSnapShot);
              posts.add(post);
              break;
            case DocumentChangeType.modified:
              await getLikers(docSnapShot);
              Post post = cookPost(docSnapShot);
              posts[getIndexOfChangedPost(docSnapShot.id)] = post;
              break;
            case DocumentChangeType.removed:
              postsUsersLikes.remove(docSnapShot.id);
              posts.removeAt(getIndexOfChangedPost(docSnapShot.id));
          }
          if (posts.length == event.docs.length) {
            posts.sort((p1, p2) => p1.compare(p2));
            emit(PostsOnReadSuccess());
          }
        });
      });
    } catch (err) {
      emit(PostsOnReadFailed());
    }
  }

  Post cookPost(DocumentSnapshot<Map<String, dynamic>> docSnapShot) {
    var json = docSnapShot.data()!;
    Post post = Post.fromJson(json);
    return post;
  }

  int getIndexOfChangedPost(String id) {
    return posts.indexWhere((element) => element.postId == id);
  }

  getLikers(DocumentSnapshot<Map<String, dynamic>> docSnapShot,
      {bool added = false}) async {
    QuerySnapshot querySnapshot =
        await docSnapShot.reference.collection(POST_LIKES_COLLECTION).get();
    List<String> usersIds = [];
    querySnapshot.docs.forEach((element) {
      usersIds.add(element.id);
    });
    if (added && usersIds.contains(generalUser.uId))
      postsMyLikes[docSnapShot.id] = true;
    postsUsersLikes[docSnapShot.id] = List.from(usersIds);
  }

  cancelListener() {
    subscription.cancel();
  }

  removePost(int index) async {
    try {
      await PostFirebase.removePost(posts[index].postId);
    } catch (err) {
      showToast('Unknown problem, try again');
    }
  }

  bool getRemoveIconOpacity(int index) {
    return generalUser.postsIds.contains(posts[index].postId);
  }

  onProfileClick(context, String uId) async {
    if (generalUser.authority == HIGH_BOARD_AUTHORITY) {
      UserModel user =
          UserModel.fromJson((await UserFirebase.getAnotherUser(uId)).data()!);
      navigate(
          context,
          ProfileScreen(
            user: user,
          ));
    } else if (generalUser.authority == ON_BOARD_AUTHORITY) {
      try {
        UserModel user = UserModel.fromJson(
            (await UserFirebase.getAnotherUser(uId)).data()!);
        if (user.teamName == generalUser.teamName)
          navigate(
              context,
              ProfileScreen(
                user: user,
              ));
        else {
          showToast(
              'you can\'t view the profile of a member of a another team.');
        }
      } catch (err) {}
    }
  }

  createPost(Post post) async {
    emit(PostOnCreateLoading());
    try {
      await PostFirebase.createPost(post);
      emit(PostOnCreateSuccess());
    } on FirebaseException catch (err) {
      emit(PostOnCreateFailed(err.code));
    }
  }

  bool stillWorking = false;

  likePost({required int postIndex, required int currentLikeCount}) async {
    try {
      String postId = posts[postIndex].postId;
      if (stillWorking) return;
      stillWorking = true;
      if (!isLiked(postIndex)) {
        await PostFirebase.likePost(postId, getUId(), currentLikeCount);
        postsMyLikes[postId] = true;
      } else {
        await PostFirebase.unLikePost(postId, getUId(), currentLikeCount);
        postsMyLikes.remove(postId);
      }
      stillWorking = false;
      emit(PostOnLikeState());
    } catch (err) {}
  }

  String getUId() {
    return UserFirebase.getUid();
  }

  bool isLiked(int postIndex) {
    return postsMyLikes.containsKey(posts[postIndex].postId);
  }
}
