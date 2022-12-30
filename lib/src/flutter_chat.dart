import 'dart:io';
import 'package:custom_chat/custom_chat.dart';
import 'package:custom_chat/src/widgets/left_chat_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widgets/right_chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

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

  static Future<void> onGroupSendMessage({
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required TextEditingController msgTextController,
    required String type,
    required FieldValue time,
    String? mediaUrl,
    String? uid,
  }) async {
    if (msgTextController.text.trim().isNotEmpty) {
      Map<String, dynamic> chatData = {
        "sendBy": senderName,
        "message": msgTextController.text.trim(),
        "type": type,
        "time": FieldValue.serverTimestamp(),
        "mediaUrl": mediaUrl,
        "seen": false,
        "uid": uid
      };

      msgTextController.clear();

      await FirebaseFirestore.instance
          .collection(groupChatRoomCollectionName)
          .doc(groupChatRoomId)
          .collection(groupChatsCollectionName)
          .add(chatData);
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
                                              icon: const Icon(Icons.photo,
                                                  color: Colors.blueGrey),
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
                                              icon: const Icon(Icons.camera_alt,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
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
                          backgroundColor: Colors.teal,
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

  Widget groupMessageField({
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
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
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
    String? uid = "",
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
                                              onPressed: () {
                                                getGroupBottomSheet(context,
                                                    senderName: senderName,
                                                    groupChatRoomId:
                                                        groupChatRoomId,
                                                    groupChatRoomCollectionName:
                                                        groupChatRoomCollectionName,
                                                    groupChatsCollectionName:
                                                        groupChatsCollectionName,
                                                    isCamera: false,
                                                    time: time,
                                                    uid: uid.toString());
                                              },
                                              icon: const Icon(Icons.photo,
                                                  color: Colors.blueGrey),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                getGroupBottomSheet(context,
                                                    senderName: senderName,
                                                    groupChatRoomId:
                                                        groupChatRoomId,
                                                    groupChatRoomCollectionName:
                                                        groupChatRoomCollectionName,
                                                    groupChatsCollectionName:
                                                        groupChatsCollectionName,
                                                    isCamera: true,
                                                    time: time,
                                                    uid: uid.toString());
                                              },
                                              icon: const Icon(Icons.camera_alt,
                                                  color: Colors.blueGrey),
                                            ),
                                          ],
                                        )
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white70),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )),
                ),
                isSizeBoxEnable ? const SizedBox(width: 5) : Container(),
                isSendButtonEnable
                    ? floatingActionButton ??
                        FloatingActionButton(
                          elevation: 0,
                          backgroundColor: Colors.teal,
                          onPressed: () {
                            onGroupSendMessage(
                                senderName: senderName,
                                groupChatRoomId: groupChatRoomId,
                                groupChatRoomCollectionName:
                                    groupChatRoomCollectionName,
                                groupChatsCollectionName:
                                    groupChatsCollectionName,
                                msgTextController: msgTextController,
                                type: type,
                                time: time,
                                mediaUrl: mediaUrl,
                                uid: uid);
                          },
                          child: const Icon(Icons.send),
                        )
                    : Container(),
              ],
            ),
          ),
    );
  }

  static Future<void> createGroup({
    required String groupName,
    required List<Map<String, dynamic>> membersList,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String groupUsersCollectionName,
  }) async {
    String groupId = const Uuid().v1();

    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupId)
        .set({
      "members": membersList,
      "id": groupId,
      "name": groupName,
      "groupImage": "",
    });

    for (int i = 0; i < membersList.length; i++) {
      String uid = membersList[i]['uid'];

      await FirebaseFirestore.instance
          .collection(groupUsersCollectionName)
          .doc(uid)
          .collection(groupChatRoomCollectionName)
          .doc(groupId)
          .set({
        "name": groupName,
        "id": groupId,
      });
    }

    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupId)
        .collection(groupChatsCollectionName)
        .add({
      "message":
          "${FirebaseAuth.instance.currentUser!.displayName} Created This Group.",
      "time": DateTime.now(),
      "type": "notify",
      "sendBy": FirebaseAuth.instance.currentUser!.displayName
    });
  }

  static Widget leftChatBubble({
    String? message,
    Color? transFormColor,
    Color? containerColor,
    Decoration? decoration,
    EdgeInsets? padding,
    TextStyle? messageStyle,
    LeftBubbleType? bubbleType,
    bool? isStatusAvailable,
    required Map<String?, dynamic> userDetailsMap,
  }) {
    return LeftChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
      userDetailsMap: userDetailsMap,
      isStatusAvailable: isStatusAvailable ?? false,
    );
  }

  static Widget groupLeftChatBubble({
    String? message,
    Color? transFormColor,
    Color? containerColor,
    Decoration? decoration,
    EdgeInsets? padding,
    TextStyle? messageStyle,
    GroupLeftBubbleType? bubbleType,
    bool? isStatusAvailable,
    required Map<String?, dynamic> userDetailsMap,
  }) {
    return GroupLeftChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
      userDetailsMap: userDetailsMap,
      isStatusAvailable: isStatusAvailable ?? false,
    );
  }

  static Widget rightChatBubble({
    String? message,
    Color? transFormColor,
    Color? containerColor,
    Decoration? decoration,
    EdgeInsets? padding,
    TextStyle? messageStyle,
    BubbleType? bubbleType,
    bool? isStatusAvailable,
    required Map<String?, dynamic> userDetailsMap,
  }) {
    return RightChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
      userDetailsMap: userDetailsMap,
      isStatusAvailable: isStatusAvailable ?? false,
    );
  }

  static Widget groupRightChatBubble(
      {String? message,
      Color? transFormColor,
      Color? containerColor,
      Decoration? decoration,
      EdgeInsets? padding,
      TextStyle? messageStyle,
      GroupRightBubbleType? bubbleType,
      bool? isStatusAvailable,
      required Map<String?, dynamic> userDetailsMap,
      String? uid,
      String? messageId}) {
    return GroupRightChatBubble(
      message: message,
      transFormColor: transFormColor,
      containerColor: containerColor,
      decoration: decoration,
      padding: padding,
      messageStyle: messageStyle,
      bubbleType: bubbleType,
      userDetailsMap: userDetailsMap,
      isStatusAvailable: isStatusAvailable ?? false,
      uid: uid,
      messageId: messageId,
    );
  }
  // static Widget rightChatBubble(
  //     {String? message,
  //       Color? transFormColor,
  //       Color? containerColor,
  //       Decoration? decoration,
  //       EdgeInsets? padding,
  //       TextStyle? messageStyle,
  //       BubbleType? bubbleType}) {
  //   return RightChatBubble(
  //     message: message,
  //     transFormColor: transFormColor,
  //     containerColor: containerColor,
  //     decoration: decoration,
  //     padding: padding,
  //     messageStyle: messageStyle,
  //     bubbleType: bubbleType,
  //   );
  // }

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

  getGroupBottomSheet(
    context, {
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required bool isCamera,
    required FieldValue time,
    required String uid,
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
                  getGroupVideo(
                      senderName: senderName,
                      groupChatRoomId: groupChatRoomId,
                      groupChatRoomCollectionName: groupChatRoomCollectionName,
                      groupChatsCollectionName: groupChatsCollectionName,
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
                  getGroupImage(
                    senderName: senderName,
                    groupChatRoomId: groupChatRoomId,
                    groupChatRoomCollectionName: groupChatRoomCollectionName,
                    groupChatsCollectionName: groupChatsCollectionName,
                    type: "image",
                    time: time,
                    isCamera: isCamera,
                  );
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.audio_file),
                title: const Text("Audio"),
                onTap: () {
                  selectFile(
                      groupChatRoomId: groupChatRoomId,
                      groupChatRoomCollectionName: groupChatRoomCollectionName,
                      groupChatsCollectionName: groupChatsCollectionName,
                      senderName: senderName);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_copy_outlined),
                title: const Text("Documents"),
                onTap: () {
                  uploadDocument(
                      groupChatRoomId: groupChatRoomId,
                      groupChatRoomCollectionName: groupChatRoomCollectionName,
                      groupChatsCollectionName: groupChatsCollectionName,
                      senderName: senderName,
                      uid: uid);
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
        uploadGroupImage(
            imageFile: File(xFile.path),
            senderName: senderName,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
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

  static Future uploadGroupImage({
    required File imageFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
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
        "seen": false
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
        uploadGroupVideo(
            videoFile: File(xFile.path),
            senderName: senderName,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
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

  uploadGroupVideo({
    required File videoFile,
    required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String type,
    required FieldValue time,
    String? mediaUrl,
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

  static Future groupChatSeenChatList({
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String currentUserName,
    //  required List membersList,
  }) async {
    try {
      var collection = FirebaseFirestore.instance
          .collection("groups")
          .doc(groupChatRoomId)
          .collection("chats");
      var querySnapshots = await collection.get();

      for (var doc in querySnapshots.docs) {
        // if (membersList.contains(doc['sendBy'])) {
        //   await FirebaseFirestore.instance
        //       .collection(groupChatRoomCollectionName)
        //       .doc(groupChatRoomId)
        //       .collection(groupChatsCollectionName)
        //       .doc(doc.id)
        //       .update({"seen": true});
        // }
        if (doc['sendBy'] != currentUserName) {
          await FirebaseFirestore.instance
              .collection(groupChatRoomCollectionName)
              .doc(groupChatRoomId)
              .collection(groupChatsCollectionName)
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

  static Future<void> onAddMembers({
    required List membersList,
    required String groupChatId,
    required String groupName,
    required String groupChatRoomCollectionName,
    required String groupUsersCollectionName,
    required Map<String, dynamic>? userMap,
  }) async {
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .update({
      "members": membersList,
    });
    await FirebaseFirestore.instance
        .collection(groupUsersCollectionName)
        .doc(userMap!['uid'])
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .set({"name": groupName, "id": groupChatId});
  }

  static Future<void> removeMembers(
      {required List membersList,
      required String groupChatId,
      required String groupChatRoomCollectionName,
      required String groupUsersCollectionName,
      required int index}) async {
    String uid = membersList[index]['uid'];
    membersList.removeAt(index);
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .update({
      "members": membersList,
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection(groupUsersCollectionName)
          .doc(uid)
          .collection(groupChatRoomCollectionName)
          .doc(groupChatId)
          .delete();
    });
  }

  static Future<void> onLeaveGroup({
    required List membersList,
    required String groupChatId,
    required String groupChatRoomCollectionName,
    required String groupUsersCollectionName,
  }) async {
    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == FirebaseAuth.instance.currentUser!.uid) {
        membersList.removeAt(i);
      }
    }

    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .update({
      "members": membersList,
    });

    await FirebaseFirestore.instance
        .collection(groupUsersCollectionName)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .delete();
  }

  static Future<void> onGroupChatUpdateName({
    required String groupUsersCollectionName,
    required String groupChatId,
    required String groupName,
    required List membersList,
    required String groupChatRoomCollectionName,
  }) async {
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .update({"name": groupName});

    for (int i = 0; i < membersList.length; i++) {
      String uid = membersList[i]['uid'];

      await FirebaseFirestore.instance
          .collection(groupUsersCollectionName)
          .doc(uid)
          .collection(groupChatRoomCollectionName)
          .doc(groupChatId)
          .update({"name": groupName});
    }
  }

  static Future<void> onGroupDelete({
    required String groupChatId,
    required List membersList,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String groupUsersCollectionName,
  }) async {
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .delete();
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .collection(groupChatsCollectionName)
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    for (int i = 0; i < membersList.length; i++) {
      String uid = membersList[i]['uid'];

      await FirebaseFirestore.instance
          .collection(groupUsersCollectionName)
          .doc(uid)
          .collection(groupChatRoomCollectionName)
          .doc(groupChatId)
          .delete();
    }
  }

  static Future<void> groupMessageDelete(
      {required String groupChatId,
      required String groupChatRoomCollectionName,
      required String groupChatsCollectionName,
      required String messageId}) async {
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .collection(groupChatsCollectionName)
        .doc(messageId)
        .delete();
  }

  static Future<void> groupMessageUpdate(
      {required String groupChatId,
      required String groupChatRoomCollectionName,
      required String groupChatsCollectionName,
      required String messageId,
      required String message}) async {
    await FirebaseFirestore.instance
        .collection(groupChatRoomCollectionName)
        .doc(groupChatId)
        .collection(groupChatsCollectionName)
        .doc(messageId)
        .update({"message": message});
  }

  static Future getGroupProfileImage({
    File? imageFile,
    // required String senderName,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    //required String groupChatsCollectionName,
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
          // print('path$imageFile');
        }
        uploadGroupProfileImage(
            imageFile: File(xFile.path),
            // senderName: senderName,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            //   groupChatsCollectionName: groupChatsCollectionName,
            type: type,
            time: time,
            mediaUrl: mediaUrl);
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
    // String chatID = const Uuid().v1();
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
        if (kDebugMode) {
          print('error');
        }
      });
    }
  }

  static Future<void> sendAudioMsg({
    String? audioMsg,
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
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
          "mediaUrl": audioMsg
        });
      }).catchError((error) async {
        if (kDebugMode) {
          print('error');
        }
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
  }) async {
    final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
        'Audio/audio - ${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
    UploadTask task = firebaseStorageRef.putFile(File(recordFilePath));
    task.then((value) async {
      var audioURL = await value.ref.getDownloadURL();
      String strVal = audioURL.toString();
      // await sendAudioMsg(strVal);
      await FlutterChat.sendAudioMsg(
          audioMsg: strVal,
          groupChatRoomId: groupChatRoomId,
          groupChatRoomCollectionName: groupChatRoomCollectionName,
          groupChatsCollectionName: groupChatsCollectionName,
          senderName: senderName);
    }) /*.catchError((e) {
      if (kDebugMode) {
        print(e);
      }
    })*/
        ;
  }

  static Future<void> selectFile({
    required String groupChatRoomId,
    required String groupChatRoomCollectionName,
    required String groupChatsCollectionName,
    required String senderName,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      //type: FileType.custom,
      type: FileType.audio,
      //allowedExtensions: ['mp3', 'wav', 'aac'],
      // allowedExtensions: [
      //   'mp3',
      //   'pdf',
      //   'doc',
      //   'docx',
      //   'ppt',
      //   'pptx',
      //   'xls',
      //   'xlsx',
      //   'txt',
      //   'zip',
      //   'rar',
      // ],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'Audio/audio - ${DateTime.now().millisecondsSinceEpoch.toString()}.mp3');
      UploadTask task = firebaseStorageRef.putFile(file);
      task.then((value) async {
        var audioURL = await value.ref.getDownloadURL();
        String strVal = audioURL.toString();
        // await sendAudioMsg(strVal);
        await FlutterChat.sendAudioMsg(
            audioMsg: strVal,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            senderName: senderName);
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print('error');
      }
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
      if (kDebugMode) {
        print('extension${result.files[0].extension}');
      }
      final Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(
          'Documents/document - ${DateTime.now().millisecondsSinceEpoch.toString()}');
      UploadTask task = firebaseStorageRef.putFile(file);
      task.then((value) async {
        var documentURL = await value.ref.getDownloadURL();
        String strVal = documentURL.toString();
        // await sendAudioMsg(strVal);
        await FlutterChat.sendDocumentMsg(
            documentMsg: strVal,
            groupChatRoomId: groupChatRoomId,
            groupChatRoomCollectionName: groupChatRoomCollectionName,
            groupChatsCollectionName: groupChatsCollectionName,
            senderName: senderName,
            extension: result.files[0].extension!,
            isDownloaded: false,
            uid: uid);
      }).catchError((e) {
        if (kDebugMode) {
          print(e);
        }
      });
    } else {
      if (kDebugMode) {
        print('error');
      }
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
          'uid': uid
        });
      }).catchError((error) async {
        if (kDebugMode) {
          print('error');
        }
      });
    }
  }
}
