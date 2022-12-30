import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'custom_painter.dart';
import 'package:intl/intl.dart';

class GroupLeftChatBubble extends StatelessWidget {
  final String? message;
  final Color? transFormColor;
  final Color? containerColor;
  final Decoration? decoration;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final GroupLeftBubbleType? bubbleType;
  final Map<String?, dynamic> userDetailsMap;
  final bool isStatusAvailable;
  const GroupLeftChatBubble(
      {Key? key,
      this.message,
      this.transFormColor,
      this.containerColor,
      this.decoration,
      this.messageStyle,
      this.padding,
      this.bubbleType = GroupLeftBubbleType.type1,
      required this.userDetailsMap,
      this.isStatusAvailable = false})
      : super(key: key);

  setBubbleType() {
    switch (bubbleType) {
      case GroupLeftBubbleType.type1:
        return groupLeftSide1(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message,
            userMap: userDetailsMap,
            isStatusAvailable: isStatusAvailable);
      case GroupLeftBubbleType.type2:
        return groupLeftSide2(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle,
            userMap: userDetailsMap,
            isStatusAvailable: isStatusAvailable);
      default:
        return groupLeftSide1(
          messageStyle: messageStyle,
          transFormColor: transFormColor,
          containerColor: containerColor,
          decoration: decoration,
          padding: padding,
          message: message,
          userMap: userDetailsMap,
          isStatusAvailable: isStatusAvailable,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return setBubbleType();
  }
}

groupLeftSide1(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isStatusAvailable,
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
                    child: isStatusAvailable != false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap!['sendBy'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.lime.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    message.toString(),
                                    style: messageStyle ??
                                        const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 14, bottom: 14.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap!['sendBy'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.lime.shade700,
                                    ),
                                  ),
                                  Text(
                                    message.toString(),
                                    style: messageStyle ??
                                        const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )),
                //const SizedBox(width: 10),
                isStatusAvailable != false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            userMap['time'] != null
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

groupLeftSide2(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isStatusAvailable,
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
                    child: isStatusAvailable != false
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 5.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap!['sendBy'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.lime.shade700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    message.toString(),
                                    style: messageStyle ??
                                        const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Padding(
                            padding:
                                const EdgeInsets.only(top: 14, bottom: 14.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userMap!['sendBy'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.lime.shade700,
                                    ),
                                  ),
                                  Text(
                                    message.toString(),
                                    style: messageStyle ??
                                        const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          )),
                //const SizedBox(width: 10),
                isStatusAvailable != false
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 3.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            userMap['time'] != null
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

enum GroupLeftBubbleType { type1, type2 }
