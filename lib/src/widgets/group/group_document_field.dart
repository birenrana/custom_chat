// ignore_for_file: depend_on_referenced_packages
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class GroupDocumentField {
  static Future getGroupImage({
    File? imageFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required bool isCamera,
    required FieldValue time,
    String? mediaUrl,
    required String uid,
  }) async {
    ImagePicker picker = ImagePicker();
    await picker
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadGroupImage(
            imageFile: File(xFile.path),
            senderName: senderName,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl,
            uid: uid);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  static Future uploadGroupImage({
    required File imageFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
    required String uid,
  }) async {
    String chatID = const Uuid().v1();
    int status = 1;
    var ref = FirebaseStorage.instance.ref().child('images').child(chatID);

    if (status == 1) {
      await FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .doc(chatID)
          .set({
        "sendBy": senderName,
        "message": "",
        "type": type,
        "time": time,
        "mediaUrl": "",
        "seen": false,
        "uid": uid
      });
      status = 2;
    }
    if (status == 2) {
      ref.putFile(imageFile).then((p0) async {
        String mediaUrl = await p0.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection(groupChatRoomCollectionName)
            .doc(groupChatRoomId)
            .collection(groupChatsCollectionName)
            .doc(chatID)
            .update({
          "sendBy": senderName,
          "message": "",
          "type": type,
          "time": time,
          "mediaUrl": mediaUrl,
          "seen": false
        });
      }).catchError((error) async {
        await FirebaseFirestore.instance
            .collection(groupChatRoomCollectionName)
            .doc(groupChatRoomId)
            .collection(groupChatsCollectionName)
            .doc(chatID)
            .delete();
      });
    }
  }

  Future getGroupVideo({
    File? videoFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required FieldValue time,
    required bool isCamera,
    String? mediaUrl,
    required String uid,
  }) async {
    ImagePicker picker = ImagePicker();
    await picker
        .pickVideo(source: isCamera ? ImageSource.camera : ImageSource.gallery)
        .then((xFile) {
      if (xFile != null) {
        videoFile = File(xFile.path);
        uploadGroupVideo(
            videoFile: File(xFile.path),
            senderName: senderName,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl,
            uid: uid);
      } else {
        debugPrint('No video selected.');
      }
    });
  }

  uploadGroupVideo({
    required File videoFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
    required String uid,
  }) async {
    String chatID = const Uuid().v1();
    int status = 1;
    var ref = FirebaseStorage.instance.ref().child('videos').child(chatID);

    if (status == 1) {
      await FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .doc(chatID)
          .set({
        "sendBy": senderName,
        "message": "",
        "type": type,
        "time": time,
        "mediaUrl": "",
        "seen": false,
        "uid": uid
      });
      status = 2;
    }
    if (status == 2) {
      ref.putFile(videoFile).then((p0) async {
        String mediaUrl = await p0.ref.getDownloadURL();
        final thumbnail = await generateThumbnail(mediaUrl);
        await FirebaseStorage.instance
            .ref()
            .child('thumbnail')
            .child("thumbnail_$chatID")
            .putFile(File(thumbnail!))
            .then((p1) async {
          String thumbnailUrl = await p1.ref.getDownloadURL();
          FirebaseFirestore.instance
              .collection(groupChatRoomCollectionName)
              .doc(groupChatRoomId)
              .collection(groupChatsCollectionName)
              .doc(chatID)
              .update({
            "sendBy": senderName,
            "message": "",
            "type": type,
            "time": time,
            "mediaUrl": mediaUrl,
            "thumbnailUrl": thumbnailUrl,
            "seen": false
          });
        });
      }).catchError((error) async {
        await FirebaseFirestore.instance
            .collection(groupChatRoomCollectionName)
            .doc(groupChatRoomId)
            .collection(groupChatsCollectionName)
            .doc(chatID)
            .delete();
      });
    }
  }

  Future<String?> generateThumbnail(videoUrl) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      maxHeight: 320,
      quality: 25,
    );
    return fileName;
  }

  static Future getGroupProfileImage({
    File? imageFile, // required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String type,
    required bool isCamera,
    required FieldValue time,
    String? mediaUrl,
  }) async {
    ImagePicker picker = ImagePicker();
    await picker
        .pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery)
        .then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadGroupProfileImage(
            imageFile: File(xFile.path),
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl);
      } else {
        debugPrint('No Image selected.');
      }
    });
  }

  static Future uploadGroupProfileImage({
    required File imageFile,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
  }) async {
    String filePath = FirebaseAuth.instance.currentUser!.uid;
    int status = 1;
    var ref = FirebaseStorage.instance
        .ref()
        .child('group_images')
        .child('${filePath}_$groupChatRoomId');
    if (status == 1) {
      await FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .update({"groupImage": ""});
      status = 2;
    }
    if (status == 2) {
      ref.putFile(imageFile).then((p0) async {
        String mediaUrl = await p0.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection(groupChatRoomCollectionName)
            .doc(groupChatRoomId)
            .update({
          "groupImage": mediaUrl,
        });
      }).catchError((error) async {
        debugPrint(error.toString());
      });
    }
  }

  static Future<void> sendContactNumberMsg({
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String contactNumber,
    required String uid,
  }) async {
    if (contactNumber.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .doc();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "sendBy": senderName,
          "message": contactNumber,
          "type": "contactNumber",
          "time": FieldValue.serverTimestamp(),
          "seen": false,
          "uid": uid
        });
      }).catchError((error) async {
        debugPrint(error.toString());
      });
    }
  }

  static Future<void> sendAudioMsg({
    String? audioMsg,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String uid,
  }) async {
    if (audioMsg!.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .doc();
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "sendBy": senderName,
          "message": "",
          "type": "audio",
          "time": FieldValue.serverTimestamp(),
          "seen": false,
          "mediaUrl": audioMsg,
          "uid": uid
        });
      }).catchError((error) async {
        debugPrint(error.toString());
      });
    }
  }

  Future<void> uploadAudio({
    String? audioMsg,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String recordFilePath,
    required String uid,
  }) async {
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'Audio/audio - ${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
    UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
    task.then((value) async {
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      await GroupDocumentField.sendAudioMsg(
          audioMsg: strVal,
          groupChatRoomId: groupChatRoomId,
          groupChatRoomCollectionName: groupChatRoomCollectionName,
          groupChatsCollectionName: groupChatsCollectionName,
          senderName: senderName,
          uid: uid);
    }).catchError((error) async {
      debugPrint(error.toString());
    });
  }

  static Future<void> selectFile({
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String uid,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'Audio/audio - ${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
      UploadTask task = firebaseStorageRef.putFile(file);
      task.then((value) async {
        var audioURL = await value.ref.getDownloadURL();
        String strVal = audioURL.toString();
        await GroupDocumentField.sendAudioMsg(
            audioMsg: strVal,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            senderName: senderName,
            uid: uid);
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
  }

  static Future<void> uploadDocument({
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String uid,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'txt',
        'zip',
        'rar',
      ],
    );
    if (result != null) {
      File file = File(result.files.single.path!);
      result.files[0].extension;
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'Documents/document - ${DateTime.now().millisecondsSinceEpoch.toString()}');
      UploadTask task = firebaseStorageRef.putFile(file);
      task.then((value) async {
        var documentURL = await value.ref.getDownloadURL();
        String strVal = documentURL.toString();
        await GroupDocumentField.sendDocumentMsg(
            documentMsg: strVal,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            senderName: senderName,
            extension: result.files[0].extension!,
            isDownloaded: false,
            uid: uid);
      }).catchError((e) {
        debugPrint(e.toString());
      });
    }
  }

  static Future<void> sendDocumentMsg({
    String? documentMsg,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
    required String extension,
    required bool isDownloaded,
    required String uid,
  }) async {
    if (documentMsg!.isNotEmpty) {
      var ref = FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .doc();
      //  print("Chat ID: ${ref.id}");
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(ref, {
          "sendBy": senderName,
          "message": "",
          "type": "document",
          "time": FieldValue.serverTimestamp(),
          "seen": false,
          "mediaUrl": documentMsg,
          "fileName":
              '${extension}_${DateFormat('ddMMyyyyhhmmssms').format(DateTime.now())}.$extension',
          "isFileDownloaded": isDownloaded,
          'uid': uid,
          'chatId': ref.id
        });
      }).catchError((error) async {
        debugPrint(error.toString());
      });
    }
  }
}
