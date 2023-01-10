// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../custom_painter.dart';
import 'package:intl/intl.dart';

class LeftChatBubble extends StatelessWidget {
  final String? message;
  final Color? transFormColor;
  final Color? containerColor;
  final Decoration? decoration;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final LeftBubbleType? bubbleType;
  final Map<String?, dynamic> userDetailsMap;
  final bool isReadMessage;
  const LeftChatBubble(
      {Key? key,
      this.message,
      this.transFormColor,
      this.containerColor,
      this.decoration,
      this.messageStyle,
      this.padding,
      this.bubbleType = LeftBubbleType.type1,
      required this.userDetailsMap,
      this.isReadMessage = false})
      : super(key: key);

  setBubbleType() {
    switch (bubbleType) {
      case LeftBubbleType.type1:
        return leftSide(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message,
            userMap: userDetailsMap,
            isReadMessage: isReadMessage);
      case LeftBubbleType.type2:
        return leftSide2(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle,
            userMap: userDetailsMap,
            isReadMessage: isReadMessage);
      default:
        return leftSide(
          messageStyle: messageStyle,
          transFormColor: transFormColor,
          containerColor: containerColor,
          decoration: decoration,
          padding: padding,
          message: message,
          userMap: userDetailsMap,
          isReadMessage: isReadMessage,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return setBubbleType();
  }
}

leftSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isReadMessage,
    Map<String?, dynamic>? userMap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: CustomPaint(
          painter: CustomShape(transFormColor ?? Colors.white),
        ),
      ),
      Flexible(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: padding ?? const EdgeInsets.only(right: 10.0, left: 14.0),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                    child: isReadMessage != false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.toString(),
                                style: messageStyle ??
                                    const TextStyle(
                                        color: Colors.black, fontSize: 16),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 14, bottom: 14.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.toString(),
                                style: messageStyle ??
                                    const TextStyle(
                                        color: Colors.black, fontSize: 16),
                              ),
                            ),
                          )),
                //const SizedBox(width: 10),
                isReadMessage != false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            userMap!['time'] != null
                                ? Text(
                                    DateFormat('h:mm:a')
                                        .format(userMap['time'].toDate()),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.30),
                                      fontSize: 12,
                                    ))
                                : Container(),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

leftSide2(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isReadMessage,
    Map<String?, dynamic>? userMap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: CustomPaint(
          painter: CustomLeftReverseShape(transFormColor ?? Colors.white),
        ),
      ),
      Flexible(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          padding: padding ?? const EdgeInsets.only(right: 10.0, left: 14.0),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
          child: IntrinsicWidth(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                    child: isReadMessage != false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.toString(),
                                style: messageStyle ??
                                    const TextStyle(
                                        color: Colors.black, fontSize: 16),
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 14, bottom: 14.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                message.toString(),
                                style: messageStyle ??
                                    const TextStyle(
                                        color: Colors.black, fontSize: 16),
                              ),
                            ),
                          )),
                //const SizedBox(width: 10),
                isReadMessage != false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            userMap!['time'] != null
                                ? Text(
                                    DateFormat('h:mm:a')
                                        .format(userMap['time'].toDate()),
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(.30),
                                      fontSize: 12,
                                    ))
                                : Container(),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

enum LeftBubbleType { type1, type2 }
