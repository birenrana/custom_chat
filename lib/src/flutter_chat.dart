import 'dart:io';
import 'package:custom_chat/src/widgets/left_chat_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/right_chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class FlutterChat {
  static sendMessage({
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required TextEditingController msgTextController,
    required String type,
    required FieldValue time,
    String? mediaUrl,
  }) async {
    if (msgTextController.text.trim().isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": senderName,
        "message": msgTextController.text.trim(),
        "type": type,
        "time": time,
        "mediaUrl": mediaUrl,
        "seen": false
      };

      msgTextController.clear();
      await FirebaseFirestore.instance
          .collection(chatRoomCollectionName)
          .doc(chatRoomId)
          .collection(chatsCollectionName)
          .add(messages);
    } else {
      if (kDebugMode) {
        print("Enter Some Text");
      }
    }
  }

  Widget messageField({
    required BuildContext context,
    String hintText = "Type Message",
    TextStyle? hintTextStyle = const TextStyle(color: Colors.blueGrey),
    Color? fillColor = Colors.white,
    bool? filled = true,
    InputDecoration? inputDecoration,
    FloatingActionButton? sendButton,
    Color backgroundColor = Colors.transparent,
    EdgeInsets padding =
        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
    required TextEditingController msgTextController,
    FloatingActionButton? floatingActionButton,
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String type,
    required FieldValue time,
    bool isSendButtonEnable = true,
    bool isSizeBoxEnable = true,
    Decoration? decoration,
    Container? container,
    TextField? textField,
    Widget? suffixIcon,
    Widget? prefixIcon,
    bool isSuffixIconIsVisible = true,
    String? mediaUrl = "",
  }) {
    return Padding(
      padding: padding,
      child: container ??
          Container(
            decoration: decoration ??
                BoxDecoration(
                  color: backgroundColor,
                ),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: textField ??
                      TextField(
                          controller: msgTextController,
                          decoration: inputDecoration ??
                              InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20.0),
                                hintText: hintText,
                                prefixIcon: prefixIcon,
                                hintStyle: hintTextStyle,
                                fillColor: fillColor,
                                filled: filled,
                                suffixIcon: isSuffixIconIsVisible
                                    ? suffixIcon ??
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              // onPressed: () {
                                              //   getImage(
                                              //       senderName: senderName,
                                              //       chatRoomId: chatRoomId,
                                              //       chatRoomCollectionName:
                                              //           chatRoomCollectionName,
                                              //       chatsCollectionName:
                                              //           chatsCollectionName,
                                              //       type: "image",
                                              //       time: time);
                                              //   // getVideo(
                                              //   //     senderName: senderName,
                                              //   //     chatRoomId: chatRoomId,
                                              //   //     chatRoomCollectionName:
                                              //   //         chatRoomCollectionName,
                                              //   //     chatsCollectionName:
                                              //   //         chatsCollectionName,
                                              //   //     type: "video",
                                              //   //     time: time);
                                              // },
                                              onPressed: () {
                                                getBottomSheet(context,
                                                    senderName: senderName,
                                                    chatRoomId: chatRoomId,
                                                    chatRoomCollectionName:
                                                        chatRoomCollectionName,
                                                    chatsCollectionName:
                                                        chatsCollectionName,
                                                    time: time,
                                                    isCamera: false);
                                              },
                                              icon: const Icon(Icons.photo),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                getBottomSheet(context,
                                                    senderName: senderName,
                                                    chatRoomId: chatRoomId,
                                                    chatRoomCollectionName:
                                                        chatRoomCollectionName,
                                                    chatsCollectionName:
                                                        chatsCollectionName,
                                                    time: time,
                                                    isCamera: true);
                                              },
                                              icon:
                                                  const Icon(Icons.camera_alt),
                                            ),
                                          ],
                                        )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.cyan),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.cyan),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.cyan),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )),
                ),
                isSizeBoxEnable ? const SizedBox(width: 5) : Container(),
                isSendButtonEnable
                    ? floatingActionButton ??
                        FloatingActionButton(
                          // clipBehavior: Clip.antiAlias,
                          // shape: const RoundedRectangleBorder(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(16.0))),
                          elevation: 0,
                          backgroundColor: Colors.cyan,
                          onPressed: () {
                            sendMessage(
                                senderName: senderName,
                                chatRoomId: chatRoomId,
                                chatRoomCollectionName: chatRoomCollectionName,
                                chatsCollectionName: chatsCollectionName,
                                msgTextController: msgTextController,
                                type: type,
                                time: time,
                                mediaUrl: mediaUrl);
                          },
                          child: const Icon(Icons.send),
                        )
                    : Container(),
              ],
            ),
          ),
    );
  }

  static Widget leftChatBubble(
      {String? message,
      Color? transFormColor,
      Color? containerColor,
      Decoration? decoration,
      EdgeInsets? padding,
      TextStyle? messageStyle,
      BubbleType2? bubbleType}) {
    return LeftChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
    );
  }

  static Widget rightChatBubble(
      {String? message,
      Color? transFormColor,
      Color? containerColor,
      Decoration? decoration,
      EdgeInsets? padding,
      TextStyle? messageStyle,
      BubbleType? bubbleType}) {
    return RightChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
    );
  }

  static deleteMessage({
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String messageId,
  }) async {
    await FirebaseFirestore.instance
        .collection(chatRoomCollectionName)
        .doc(chatRoomId)
        .collection(chatsCollectionName)
        .doc(messageId)
        .delete();
  }

  static updateMessage({
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String messageId,
    required String message,
  }) async {
    await FirebaseFirestore.instance
        .collection(chatRoomCollectionName)
        .doc(chatRoomId)
        .collection(chatsCollectionName)
        .doc(messageId)
        .update({"message": message});
  }

  // Widget emojiPicker({
  //   required TextEditingController msgTextController,
  //   required BuildContext context,
  // }) {
  //   return EmojiPicker(
  //     textEditingController: msgTextController,
  //     config: const Config(columns: 7
  //
  //         // onEmojiSelected: (emoji, category) {
  //         //   // msgTextController.text = msgTextController.text + emoji.emoji;
  //         // },
  //         ),
  //   );
  // }
  getBottomSheet(
    context, {
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required bool isCamera,
    required FieldValue time,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.video_camera_back_outlined),
                title: const Text("Video"),
                onTap: () {
                  getVideo(
                      senderName: senderName,
                      chatRoomId: chatRoomId,
                      chatRoomCollectionName: chatRoomCollectionName,
                      chatsCollectionName: chatsCollectionName,
                      isCamera: isCamera,
                      type: "video",
                      time: time);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Photo"),
                onTap: () {
                  getImage(
                    senderName: senderName,
                    chatRoomId: chatRoomId,
                    chatRoomCollectionName: chatRoomCollectionName,
                    chatsCollectionName: chatsCollectionName,
                    type: "image",
                    time: time,
                    isCamera: isCamera,
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  Future<String?> generateThumbnail(videoUrl) async {
    final fileName = await VideoThumbnail.thumbnailFile(
      video: videoUrl,
      //thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      maxHeight: 320,
      quality: 25,
    );
    return fileName;
  }

  static Future getImage({
    File? imageFile,
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
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
        if (kDebugMode) {
          print('path$imageFile');
        }
        uploadImage(
            imageFile: File(xFile.path),
            senderName: senderName,
            chatRoomId: chatRoomId,
            chatRoomCollectionName: chatRoomCollectionName,
            chatsCollectionName: chatsCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl);
      }
    });
  }

  static Future uploadImage({
    required File imageFile,
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
  }) async {
    String chatID = const Uuid().v1();
    int status = 1;
    var ref = FirebaseStorage.instance.ref().child('images').child(chatID);

    if (status == 1) {
      await FirebaseFirestore.instance
          .collection(chatRoomCollectionName)
          .doc(chatRoomId)
          .collection(chatsCollectionName)
          .doc(chatID)
          .set({
        "sendby": senderName,
        "message": "",
        "type": type,
        "time": time,
        "mediaUrl": "",
        "seen": false
      });
      status = 2;
    }
    if (status == 2) {
      ref.putFile(imageFile).then((p0) async {
        String mediaUrl = await p0.ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection(chatRoomCollectionName)
            .doc(chatRoomId)
            .collection(chatsCollectionName)
            .doc(chatID)
            .update({
          "sendby": senderName,
          "message": "",
          "type": type,
          "time": time,
          "mediaUrl": mediaUrl,
          "seen": false
        });
      }).catchError((error) async {
        await FirebaseFirestore.instance
            .collection(chatRoomCollectionName)
            .doc(chatRoomId)
            .collection(chatsCollectionName)
            .doc(chatID)
            .delete();
      });
    }
  }

  Future getVideo({
    File? videoFile,
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String type,
    required FieldValue time,
    required bool isCamera,
    String? mediaUrl,
  }) async {
    ImagePicker picker = ImagePicker();
    await picker
        .pickVideo(source: isCamera ? ImageSource.camera : ImageSource.gallery)
        .then((xFile) {
      if (xFile != null) {
        videoFile = File(xFile.path);
        if (kDebugMode) {
          print('path$videoFile');
        }
        uploadVideo(
            videoFile: File(xFile.path),
            senderName: senderName,
            chatRoomId: chatRoomId,
            chatRoomCollectionName: chatRoomCollectionName,
            chatsCollectionName: chatsCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl);
      }
    });
  }

  uploadVideo({
    required File videoFile,
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
  }) async {
    String chatID = const Uuid().v1();
    int status = 1;
    var ref = FirebaseStorage.instance.ref().child('videos').child(chatID);

    if (status == 1) {
      await FirebaseFirestore.instance
          .collection(chatRoomCollectionName)
          .doc(chatRoomId)
          .collection(chatsCollectionName)
          .doc(chatID)
          .set({
        "sendby": senderName,
        "message": "",
        "type": type,
        "time": time,
        "mediaUrl": "",
        "seen": false
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
              .collection(chatRoomCollectionName)
              .doc(chatRoomId)
              .collection(chatsCollectionName)
              .doc(chatID)
              .update({
            "sendby": senderName,
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
            .collection(chatRoomCollectionName)
            .doc(chatRoomId)
            .collection(chatsCollectionName)
            .doc(chatID)
            .delete();
      });
    }
  }

  static Future seenChatList({
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required String currentUserName,
  }) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection(chatRoomCollectionName)
          .doc(chatRoomId)
          .collection(chatsCollectionName);
      var querySnapshots = await collection.get();

      for (var doc in querySnapshots.docs) {
        if (doc['sendby'] != currentUserName) {
          await FirebaseFirestore.instance
              .collection(chatRoomCollectionName)
              .doc(chatRoomId)
              .collection(chatsCollectionName)
              .doc(doc.id)
              .update({"seen": true});
        }
      }
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Exception: $e");
      }
      return null;
    }
  }

  static Future setOnlineStatus({
    String? status,
    required String usersCollectionName,
    required String currentUserId,
  }) async {
    await FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(currentUserId)
        .update({'status': status});
  }
}
