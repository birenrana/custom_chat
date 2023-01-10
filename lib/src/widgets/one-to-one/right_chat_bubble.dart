// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import '../custom_painter.dart';
import 'package:intl/intl.dart';

class RightChatBubble extends StatelessWidget {
  final String? message;
  final Color? transFormColor;
  final Color? containerColor;
  final Decoration? decoration;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final BubbleType? bubbleType;
  final Map<String?, dynamic> userDetailsMap;
  final bool isReadMessage;

  const RightChatBubble({
    Key? key,
    this.message,
    this.transFormColor,
    this.containerColor,
    this.decoration,
    this.messageStyle,
    this.padding,
    this.isReadMessage = false,
    this.bubbleType = BubbleType.type1,
    required this.userDetailsMap,
  }) : super(key: key);

  setBubbleType() {
    switch (bubbleType) {
      case BubbleType.type1:
        return upSide(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message,
            userMap: userDetailsMap,
            isReadMessage: isReadMessage);
      case BubbleType.type2:
        return bottomSide(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle,
            userMap: userDetailsMap,
            isReadMessage: isReadMessage);
      default:
        return upSide(
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

upSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isReadMessage,
    Map<String?, dynamic>? userMap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Container(
          padding: padding ??
              const EdgeInsets.only(
                  /*top: 14, bottom: 14.0,*/
                  right: 10.0,
                  left: 14.0),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.greenAccent.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
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
                            const SizedBox(
                              width: 3,
                            ),
                            userMap['seen']
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.blue,
                                    size: 16,
                                  )
                                : const Icon(
                                    Icons.done,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      CustomPaint(
          painter: CustomShape(transFormColor ?? Colors.greenAccent.shade100)),
    ],
  );
}

bottomSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isReadMessage,
    Map<String?, dynamic>? userMap}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Flexible(
        child: Container(
          padding: padding ?? const EdgeInsets.only(right: 10.0, left: 14.0),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.greenAccent.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  // bottomRight: Radius.circular(18),
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
                            const SizedBox(
                              width: 3,
                            ),
                            userMap['seen']
                                ? const Icon(
                                    Icons.done_all,
                                    color: Colors.blue,
                                    size: 16,
                                  )
                                : const Icon(
                                    Icons.done,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
      CustomPaint(
          painter: CustomReverseShape(
              transFormColor ?? Colors.greenAccent.shade100)),
    ],
  );
}

enum BubbleType { type1, type2 }
