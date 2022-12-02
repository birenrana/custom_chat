import 'package:flutter/material.dart';
import 'custom_painter.dart';

class RightChatBubble extends StatelessWidget {
  final String? message;
  final Color? transFormColor;
  final Color? containerColor;
  final Decoration? decoration;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final BubbleType? bubbleType;

  const RightChatBubble(
      {Key? key,
      this.message,
      this.transFormColor,
      this.containerColor,
      this.decoration,
      this.messageStyle,
      this.padding,
      this.bubbleType = BubbleType.type1})
      : super(key: key);

  setBubbleType() {
    switch (bubbleType) {
      case BubbleType.type1:
        return upSide(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message);
      case BubbleType.type2:
        return bottomSide(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle);
      default:
        return upSide(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message);
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
    EdgeInsets? padding}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Flexible(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: padding ??
                  const EdgeInsets.only(
                      top: 14, bottom: 14.0, right: 25.0, left: 14.0),
              constraints: const BoxConstraints(maxWidth: 300),
              decoration: decoration ??
                  BoxDecoration(
                    color: containerColor ?? Colors.blue.shade700,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      bottomLeft: Radius.circular(18),
                      bottomRight: Radius.circular(18),
                    ),
                  ),
              child: Text(
                message.toString(),
                style: messageStyle ??
                    const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(4.0),
            //   child: Icon(
            //     Icons.done_all,
            //     size: 18,
            //     color: seen == true ? Colors.black : Colors.white,
            //   ),
            // )
          ],
        ),
      ),
      CustomPaint(painter: CustomShape(transFormColor ?? Colors.blue.shade700)),
    ],
  );
}

bottomSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.end,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Flexible(
        child: Container(
          padding: padding ??
              const EdgeInsets.only(
                  top: 14, bottom: 14.0, right: 25.0, left: 14.0),
          constraints: const BoxConstraints(maxWidth: 300),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.blue.shade700,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  // bottomRight: Radius.circular(18),
                ),
              ),
          child: Text(
            message.toString(),
            style: messageStyle ??
                const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      CustomPaint(
          painter: CustomReverseShape(transFormColor ?? Colors.blue.shade700)),
    ],
  );
}

enum BubbleType { type1, type2 }
