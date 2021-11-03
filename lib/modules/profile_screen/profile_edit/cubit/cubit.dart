import 'dart:io';
import 'package:enactus/modules/profile_screen/profile_edit/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/firebase/post_firebase.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditCubit extends Cubit<ProfileEditState> {
  EditCubit() : super(EditInitState());

  static EditCubit get(context) => BlocProvider.of(context);

  ImagePicker _picker = ImagePicker();
  late File? profileImage = File('');

  takeImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(EditImagePickedSuccess());
    }
  }

  closePickedImage() {
    if (profileImage != null) profileImage = null;
    emit(EditNoImagePicked());
  }

  updateName(
    String name,
  ) async {
    try {
      await UserFirebase.updateUserField(FULL_Name_FIELD, name);
      updateUserPostsCreatorData(CREATOR_NAME_FIELD, name);
      emit(EditSuccessState());
    } catch (err) {
      emit(EditFailedState());
    }
  }

  updatePhone(
    String phone,
  ) async {
    try {
      await UserFirebase.updateUserField(PHONE_FIELD, phone);
      showToast('Done !');
    } catch (err) {
      emit(EditFailedState());
    }
  }


  updateProfileImage(File image) async {
    emit(EditLoadingState());
    try {
      String downloadUrl = await UserFirebase.uploadImage(image);
      emit(EditPhotoSuccessState());
      try {
        await UserFirebase.updateUserField(IMAGE_FIELD, downloadUrl);
        updateUserPostsCreatorData(CREATOR_IMAGE_FIELD, downloadUrl);
      } catch (err) {
        emit(EditFailedState());
      }
    } catch (err) {
      emit(EditFailedState());
    }
  }

  updateUserPostsCreatorData(String key, String value) {
    generalUser.postsIds.forEach((postId) {
      try {
        PostFirebase.updateField(postId, key, value);
      } catch (err) {}
    });
  }
}
