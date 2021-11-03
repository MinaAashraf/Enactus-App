import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/feedback.dart';
import 'package:enactus/models/notification.dart';
import 'package:enactus/models/user/user.dart';
import 'package:enactus/models/user_name_and_id.dart';
import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserFirebase {
  static final _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _fireStore = myFireStore;
  static final FirebaseStorage _storage = myStorage;

  static Future<UserCredential> createUser(
      {required String email, required String password}) async {
    UserCredential credentials = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credentials;
  }

  static Future<UserCredential> signIn(
      {required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  static resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      showToast('Reset password email is send to you',
          duration: Toast.LENGTH_LONG);
    } on FirebaseAuthException catch (err) {
      handleError(err.code);
    }
  }

  static Future<void> storeUserData(
      {required UserModel user, required String uId}) async {
    await _fireStore.collection(USERS_COLLECTION).doc(uId).set(user.toMap());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    Stream<DocumentSnapshot<Map<String, dynamic>>> snapshot =
        _fireStore.collection(USERS_COLLECTION).doc(getUid()).snapshots();
    return snapshot;
  }

  static Future<int> getUsersLength(String teamName) async {
    return (await _fireStore
            .collection(USERS_COLLECTION)
            .where(TEAM_Name_FIELD, isEqualTo: teamName)
            .get())
        .docs
        .length;
  }

  static String getUid() {
    return _auth.currentUser!.uid;
  }

  static bool isUserLogin() {
    return _auth.currentUser == null ? false : true;
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getMembers(
      String teamName) async {
    return await _fireStore
        .collection(USERS_COLLECTION)
        .where(TEAM_Name_FIELD, isEqualTo: teamName)
        .get();
  }

  static Future<DocumentSnapshot<Map<String, dynamic>>> getAnotherUser(
      String userId) async {
    return await _fireStore.collection(USERS_COLLECTION).doc(userId).get();
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getSomeUsers(
      List<String> usersIds) async {
    return await _fireStore
        .collection(USERS_COLLECTION)
        .where(FieldPath.documentId, whereIn: usersIds)
        .get();
  }

  static sendFeedbackToUser(String userId, Feedback feedback) async {
    await _fireStore.collection(USERS_COLLECTION).doc(userId).update({
      FEEDBACKS_FIELD: FieldValue.arrayUnion([feedback.toMap()])
    });
  }

  static sendNotificationToOneUser(
      UserNameAndId userNameAndId, Notification notification) async {
    await _fireStore
        .collection(USERS_COLLECTION)
        .doc(userNameAndId.uid)
        .update({
      Notifications_FIELD: FieldValue.arrayUnion([notification.toMap()])
    });
    await _fireStore.collection(USERS_COLLECTION).doc(userNameAndId.uid).update(
        {'unseenNotifications': userNameAndId.member.unseenNotifications + 1});
  }

  static sendNotificationToAllUsers(Notification notification) async {
    await _fireStore
        .collection(USERS_COLLECTION)
        .get()
        .then((value) => value.docs.forEach((element) {
              if (element.id != getUid()) {
                UserModel member = UserModel.fromJson(element.data());
                UserNameAndId userNameAndId = UserNameAndId(member, element.id);
                sendNotificationToOneUser(userNameAndId, notification);
              }
            }));
  }

  static clearUnSeenNotificationsNumber() async {
    await _fireStore
        .collection(USERS_COLLECTION)
        .doc(getUid())
        .update({'unseenNotifications': 0});
  }

  static updateUserField(
    String key,
    dynamic value,
  ) async {
    await _fireStore
        .collection(USERS_COLLECTION)
        .doc(getUid())
        .update({key: value});
  }

  static updateAnotherUserField(String key, dynamic value, String uId) async {
    await _fireStore.collection(USERS_COLLECTION).doc(uId).update({key: value});
  }

  static Future<QuerySnapshot<Map<String, dynamic>>>
      getUsersWithProperRankRange(
          String uId, String teamName, double oldScore, double newScore) async {
    return await _fireStore
        .collection(USERS_COLLECTION)
        .where('score', isGreaterThanOrEqualTo: oldScore)
        .where('score', isLessThanOrEqualTo: newScore)
        .orderBy('score')
        .get();
  }

  static Future<String> uploadImage(File image) async {
    TaskSnapshot taskSnapshot = await _storage
        .ref()
        .child('users')
        .child('${Uri.file(image.path).pathSegments.last}')
        .putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  static Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: generalUser.email, password: currentPassword);
      try {
        await _auth.currentUser!.updatePassword(newPassword);
        showToast('Password is changed successfully',
            duration: Toast.LENGTH_LONG);
      } on FirebaseAuthException catch (err) {
        showToast(handleError(err.code));
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'wrong-password')
        showToast('Current password is wrong !');
      else
        showToast(handleError(err.code));
    }
  }

  static saveMyPostId(String postId) {
    generalUser.postsIds.add(postId);
    _fireStore
        .collection(USERS_COLLECTION)
        .doc(getUid())
        .update({POSTS_ID_FIELD: generalUser.postsIds});
  }
}
