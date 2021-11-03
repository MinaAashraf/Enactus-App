import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enactus/models/post/post.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:enactus/strings/strings.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostFirebase {
  static final _fireStore = myFireStore;
  static final _storage = myStorage;

  static Future<void> createPost(Post post) async {
    await _fireStore
        .collection(POSTS_COLLECTION)
        .doc(post.postId)
        .set(post.toMap());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return _fireStore.collection(POSTS_COLLECTION).snapshots();
  }

  static removePost(String postId) async {
    await _fireStore.collection(POSTS_COLLECTION).doc(postId).delete();
  }

  static likePost(String postId, String userId, int currentLikesCount) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _fireStore.collection(POSTS_COLLECTION).doc(postId);
    _fireStore.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await transaction.get(documentReference);

      int newLikes = snapshot.data()!['$POST_LIKES_COUNT'] + 1;
      transaction.update(documentReference, {'$POST_LIKES_COUNT': newLikes});
    });

   await documentReference
        .collection(POST_LIKES_COLLECTION)
        .doc(userId)
        .set({'like': true});
  }

  static unLikePost(String postId, String userId, int currentLikesCount) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        _fireStore.collection(POSTS_COLLECTION).doc(postId);
    _fireStore.runTransaction((transaction) async {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await transaction.get(documentReference);

      int newLikes = snapshot.data()!['$POST_LIKES_COUNT'] -1 ;
      transaction.update(documentReference, {'$POST_LIKES_COUNT': newLikes});
    });
    await documentReference
        .collection(POST_LIKES_COLLECTION)
        .doc(userId)
        .delete();
  }

  static Future<String> uploadImage(File image) async {
    TaskSnapshot taskSnapshot = await _storage
        .ref()
        .child('posts')
        .child('${Uri.file(image.path).pathSegments.last}')
        .putFile(image);
    return await taskSnapshot.ref.getDownloadURL();
  }

  static updateField(String postId, String key, String value) {
    _fireStore.collection(POSTS_COLLECTION).doc(postId).update({key: value});
  }
}
