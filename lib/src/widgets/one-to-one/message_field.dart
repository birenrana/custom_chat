// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../custom_chat.dart';

class OneToOneMessageField {
  static sendMessage({
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required TextEditingController msgTextController,
    required String type,
    required FieldValue time,
    required String uid,
    // String? mediaUrl,
  }) async {
    if (msgTextController.text.trim().isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": senderName,
        "message": msgTextController.text.trim(),
        "type": type,
        "time": time,
        //  "mediaUrl": mediaUrl ?? "",
        "uid": uid,
        "seen": false
      };

      msgTextController.clear();
      await FirebaseFirestore.instance
          .collection(chatRoomCollectionName)
          .doc(chatRoomId)
          .collection(chatsCollectionName)
          .add(messages);
    } else {
      debugPrint('Please type a message');
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
    // String? mediaUrl = "",
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
                          minLines:1,
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

  static Widget leftChatBubble({
    String? message,
    Color? transFormColor,
    Color? containerColor,
    Decoration? decoration,
    EdgeInsets? padding,
    TextStyle? messageStyle,
    LeftBubbleType? bubbleType,
    bool? isReadMessage,
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
      isReadMessage: isReadMessage ?? false,
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
    bool? isReadMessage,
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
      isReadMessage: isReadMessage ?? false,
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
      debugPrint(e.toString());
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
