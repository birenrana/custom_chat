import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'custom_painter.dart';

class LeftChatBubble extends StatelessWidget {
  final String? message;
  final Color? transFormColor;
  final Color? containerColor;
  final Decoration? decoration;
  final TextStyle? messageStyle;
  final EdgeInsets? padding;
  final BubbleType2? bubbleType;
  const LeftChatBubble(
      {Key? key,
      this.message,
      this.transFormColor,
      this.containerColor,
      this.decoration,
      this.messageStyle,
      this.padding,
      this.bubbleType = BubbleType2.type1})
      : super(key: key);

  setBubbleType() {
    switch (bubbleType) {
      case BubbleType2.type1:
        return leftSide(
            messageStyle: messageStyle,
            transFormColor: transFormColor,
            containerColor: containerColor,
            decoration: decoration,
            padding: padding,
            message: message);
      case BubbleType2.type2:
        return leftSide2(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle);
      default:
        return leftSide(
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

leftSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: CustomPaint(
          painter: CustomShape(transFormColor ?? Colors.grey[400]!),
        ),
      ),
      Flexible(
        child: Container(
          padding: padding ?? const EdgeInsets.all(14),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
          child: Text(
            message.toString(),
            style: messageStyle ??
                const TextStyle(color: Colors.black, fontSize: 20),
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
    EdgeInsets? padding}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(math.pi),
        child: CustomPaint(
          painter: CustomLeftReverseShape(transFormColor ?? Colors.grey[400]!),
        ),
      ),
      Flexible(
        child: Container(
          padding: padding ?? const EdgeInsets.all(14),
          decoration: decoration ??
              BoxDecoration(
                color: containerColor ?? Colors.grey[400],
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
          child: Text(
            message.toString(),
            style: messageStyle ??
                const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    ],
  );
}

enum BubbleType2 { type1, type2 }
