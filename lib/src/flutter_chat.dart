import 'package:custom_chat/src/widgets/left_chat_bubble.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'widgets/right_chat_bubble.dart';

class FlutterChat {
  static sendMessage({
    required String senderName,
    required String chatRoomId,
    required String chatRoomCollectionName,
    required String chatsCollectionName,
    required TextEditingController msgTextController,
    required String type,
    required FieldValue time,
  }) async {
    if (msgTextController.text.trim().isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": senderName,
        "message": msgTextController.text.trim(),
        "type": type,
        "time": time,
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
                                hintStyle: hintTextStyle,
                                fillColor: fillColor,
                                filled: filled,
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
                            );
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
}
