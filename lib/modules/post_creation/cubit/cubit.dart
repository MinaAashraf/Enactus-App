import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/notification.dart';
import 'package:enactus/models/post/post.dart';
import 'package:enactus/modules/post_creation/cubit/states.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/fcm_api/dio_helper.dart';
import 'package:enactus/shared/network/remote/firebase/post_firebase.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class PostCreationCubit extends Cubit<PostCreationStates> {
  final int postOrder;

  PostCreationCubit(this.postOrder) : super(PostCreateInitState());

  static PostCreationCubit get(context) => BlocProvider.of(context);

  ImagePicker _picker = ImagePicker();
  File? postImage;

  takeImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostCreateImagePickedState());
    }
  }

  closeImage(String txt) {
    if (postImage != null) postImage = null;
    setPostButtonOnPressed(txt);
  }

  createPost(String postTxt) async {
    emit(PostCreateLoadingState());

    if (postImage != null) {
      PostFirebase.uploadImage(postImage!).then((url) {
        _buildPost(postTxt, image: url);
      }).catchError((err) {
        emit(PostCreatedFailedState());
      });
    } else {
      _buildPost(postTxt);
    }
  }

  _buildPost(String postTxt, {String? image}) {
    Timestamp date = Timestamp.now();
    Post post = Post(
        creatorName: generalUser.fullName,
        creatorImage: generalUser.image,
        creatorAuthority: generalUser.authority,
        creatorId: UserFirebase.getUid(),
        dateTime: date,
        text: postTxt,
        postImage: image,
        postId: '$date${UserFirebase.getUid()}');
    PostFirebase.createPost(post).then((value) {
      try {
        emit(PostCreatedSuccessState());
        UserFirebase.saveMyPostId(post.postId);
      } catch (err) {}
      _sendPostNotification();
      FcmDioHelper.pushFcmNotification(
          generalUser.fullName + ' has a new post.',
          postTxt.length > 50 ? postTxt.substring(0, 50) : postTxt,
          generalUser.image,
          true);
    }).catchError((err) {
      emit(PostCreatedFailedState());
    });
  }

  _sendPostNotification() {
    Notification notification = Notification(
        generalUser.image,
        generalUser.fullName.substring(0, generalUser.fullName.indexOf(" ")) +
            ' has a new post.',
        Timestamp.now());
    try {
      UserFirebase.sendNotificationToAllUsers(notification);
    } catch (err) {}
  }

  void Function()? onPostPressed;

  setPostButtonOnPressed(String txt) {
    if (txt.isEmpty && postImage == null)
      onPostPressed = null;
    else
      onPostPressed = () => createPost(txt);
    emit(PostCreationEnableState());
  }
}
