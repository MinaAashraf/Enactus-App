import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/feedback.dart';
import 'package:enactus/models/notification.dart';
import 'package:enactus/models/user_name_and_id.dart';
import 'package:enactus/modules/feedback_screen/cubit/states.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/shared/network/remote/fcm_api/dio_helper.dart';
import 'package:enactus/shared/network/remote/firebase/feedback_files_firebase.dart';
import 'package:enactus/shared/network/remote/firebase/user_firebase.dart';
import 'package:enactus/strings/strings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FeedbackCubit extends Cubit<FeedbackStates> {
  FeedbackCubit() : super(FeedbackInitStates());

  static FeedbackCubit get(context) => BlocProvider.of(context);

  List<UserNameAndId> members = [];

  getMembers(List<UserNameAndId> members) {
    this.members = members;
    emit(FeedbackOnMembersSelectedState());
  }

  writeSeparatedMembersNames() {
    List<String> names = [];
    this.members.forEach((element) {
      names.add(element.member.fullName);
    });
    return names.join(', ');
  }

  List<File>? files;
  List<String>? localPaths;

  List<Map<String, String>> filesUrls = [];

  attachFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      localPaths = files!.map((file) => file.uri.pathSegments.last).toList();
      emit(FeedbackOnFilesAttach());
    } else {
      // User canceled the picker
    }
  }

  sendFeedback(int week, String message) async {
    emit(FeedbackOnLoadingSuccess());
    if (files != null) {
      try {
        files!.forEach((file) async {
          TaskSnapshot taskSnapshot = await FeedBackFilesFirebase.uploadFiles(
              file, file.uri.pathSegments.last);
          taskSnapshot.ref.getDownloadURL().then((url) async {
            filesUrls.add({taskSnapshot.ref.name: url});
            showToast(url);
            if (filesUrls.length == files!.length)
              await sendFeedbackAfterFilesHandling(week, message);
          });
        });
      } catch (err) {
        emit(FeedbackOnSendFailed(err.toString()));
      }
    } else
      await sendFeedbackAfterFilesHandling(week, message);
  }

  sendFeedbackAfterFilesHandling(int week, String message) async {
    for (UserNameAndId memberElement in members) {
      String? feedBackCreator =
          getFeedbackCreator(memberElement.member.authority);
      try {
        Feedback feedback =
            Feedback(week, feedBackCreator, message, files: filesUrls);
        await UserFirebase.sendFeedbackToUser(memberElement.uid, feedback);
        clearFiles();
        emit(FeedbackOnSendSuccess());
        sendFeedbackNotification(memberElement, message);
        sendServerNotification(feedback);
      } catch (err) {
        emit(FeedbackOnSendFailed(err.toString()));
      }
    }
  }

  clearFiles() {
    files = null;
    localPaths = null;
    filesUrls.clear();
  }

  removeFile(int index) {
    files!.removeAt(index);
    localPaths!.removeAt(index);
    emit(FeedbackOnRemoveAttachedFile());
  }

  sendServerNotification(Feedback feedback) async {
    try {
      await FcmDioHelper.pushFcmNotification(
          generalUser.fullName + ' has a new post.',
          feedback.message.length > 50
              ? feedback.message.substring(0, 50)
              : feedback.message,
          generalUser.image,
          false);
    } catch (err) {}
  }

  buildNotification(String receiverAuthority, String message) {
    String? url;
    String name = 'Member';
    if (receiverAuthority == ON_BOARD_AUTHORITY)
      name = 'Anonymous';
    else if ((receiverAuthority == HR_AUTHORITY &&
            generalUser.authority == ON_BOARD_AUTHORITY) ||
        receiverAuthority == USER_AUTHORITY) {
      name = generalUser.fullName;
      url = generalUser.image;
    }
    return Notification(url, 'You have a feedback from $name', Timestamp.now());
  }

  sendFeedbackNotification(UserNameAndId receiver, String feedBackMessage) {
    Notification notification =
        buildNotification(receiver.member.authority, feedBackMessage);
    try {
      UserFirebase.sendNotificationToOneUser(receiver, notification);
    } catch (err) {}
  }

  String? getFeedbackCreator(String receiverAuthority) {
    if (receiverAuthority == ON_BOARD_AUTHORITY)
      return null;
    else
      return '${generalUser.position}';
  }
}
