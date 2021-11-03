import 'dart:io';

import 'package:enactus/shared/components/components.dart';
import 'package:enactus/shared/components/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FeedBackFilesFirebase {
  static final FirebaseStorage _storage = myStorage;

  static  Future<TaskSnapshot> uploadFiles(File file, String destination) async {
   TaskSnapshot taskSnapshot = await _storage.ref().child('feedbacks').child(destination).putFile(file);
   return taskSnapshot;

  }




}
