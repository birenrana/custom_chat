// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../custom_chat.dart';

class GroupMessageField {
  static Widget groupMessageField({
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
    void Function(String)? onChanged,
    void Function()? onSuffixPressOne,
    void Function()? onSuffixPressTwo,
    void Function()? onFloatingPress,
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
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          minLines: 1,
                          onChanged: onChanged,
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
                                              onPressed: onSuffixPressOne,
                                              icon: const Icon(Icons.photo,
                                                  color: Colors.blueGrey),
                                            ),
                                            IconButton(
                                              onPressed: onSuffixPressTwo,
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
                          onPressed: onFloatingPress,
                          child: const Icon(Icons.send),
                        )
                    : Container(),
              ],
            ),
          ),
    );
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
    required uid,
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
      debugPrint('Please type a message');
    }
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

  static Widget groupLeftChatBubble({
    String? message,
    Color? transFormColor,
    Color? containerColor,
    Decoration? decoration,
    EdgeInsets? padding,
    TextStyle? messageStyle,
    GroupLeftBubbleType? bubbleType,
    bool? isReadMessage,
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
      isReadMessage: isReadMessage ?? false,
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
      bool? isReadMessage,
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
      isReadMessage: isReadMessage ?? false,
      uid: uid,
      messageId: messageId,
    );
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
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<void> isTypingStatus(
      {required String usersCollectionName,
      required String senderId,
      bool isTyping = false}) async {
    var ref = FirebaseFirestore.instance
        .collection(usersCollectionName)
        .doc(senderId);
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(ref, {
        "isTyping": isTyping,
        // "typingBy": senderName,
      });
    }).catchError((error) {
      debugPrint(error.toString());
    });
  }
}
