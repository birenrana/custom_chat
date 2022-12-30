import 'package:flutter/material.dart';
import 'custom_painter.dart';
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
  final bool isStatusAvailable;

  const RightChatBubble({
    Key? key,
    this.message,
    this.transFormColor,
    this.containerColor,
    this.decoration,
    this.messageStyle,
    this.padding,
    this.isStatusAvailable = false,
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
            isStatusAvailable: isStatusAvailable);
      case BubbleType.type2:
        return bottomSide(
            message: message,
            padding: padding,
            decoration: decoration,
            containerColor: containerColor,
            transFormColor: transFormColor,
            messageStyle: messageStyle,
            userMap: userDetailsMap,
            isStatusAvailable: isStatusAvailable);
      default:
        return upSide(
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

upSide(
    {Color? transFormColor,
    String? message,
    Color? containerColor,
    Decoration? decoration,
    TextStyle? messageStyle,
    EdgeInsets? padding,
    bool? isStatusAvailable,
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
          // child: Padding(
          //   padding: const EdgeInsets.only(top: 14, bottom: 14.0),
          //   child: RichText(
          //     text: TextSpan(
          //       text: message,
          //       style: const TextStyle(
          //         color: Colors.black,
          //         fontSize: 18,
          //       ),
          //       children: <WidgetSpan>[
          //         WidgetSpan(
          //           child: Row(
          //             mainAxisSize: MainAxisSize.min,
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             mainAxisAlignment: MainAxisAlignment.end,
          //             children: [
          //               Align(
          //                 child: userMap!['time'] != null
          //                     ? Text(
          //                         DateFormat('h:mm:a')
          //                             .format(userMap['time'].toDate()),
          //                         textAlign: TextAlign.start,
          //                         style: TextStyle(
          //                           color: Colors.black.withOpacity(.30),
          //                           fontSize: 12,
          //                         ))
          //                     : Container(),
          //               ),
          //               const SizedBox(
          //                 width: 3,
          //               ),
          //               userMap['seen']
          //                   ? const Icon(
          //                       Icons.done_all,
          //                       color: Colors.blue,
          //                       size: 16,
          //                     )
          //                   : const Icon(
          //                       Icons.done,
          //                       color: Colors.grey,
          //                       size: 16,
          //                     )
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
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
                isStatusAvailable != false
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
    bool? isStatusAvailable,
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
                    child: isStatusAvailable != false
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
                isStatusAvailable != false
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

// import 'package:flutter/material.dart';
// import 'custom_painter.dart';
//
// class RightChatBubble extends StatelessWidget {
//   final String? message;
//   final Color? transFormColor;
//   final Color? containerColor;
//   final Decoration? decoration;
//   final TextStyle? messageStyle;
//   final EdgeInsets? padding;
//   final BubbleType? bubbleType;
//
//   const RightChatBubble(
//       {Key? key,
//         this.message,
//         this.transFormColor,
//         this.containerColor,
//         this.decoration,
//         this.messageStyle,
//         this.padding,
//         this.bubbleType = BubbleType.type1})
//       : super(key: key);
//
//   setBubbleType() {
//     switch (bubbleType) {
//       case BubbleType.type1:
//         return upSide(
//             messageStyle: messageStyle,
//             transFormColor: transFormColor,
//             containerColor: containerColor,
//             decoration: decoration,
//             padding: padding,
//             message: message);
//       case BubbleType.type2:
//         return bottomSide(
//             message: message,
//             padding: padding,
//             decoration: decoration,
//             containerColor: containerColor,
//             transFormColor: transFormColor,
//             messageStyle: messageStyle);
//       default:
//         return upSide(
//             messageStyle: messageStyle,
//             transFormColor: transFormColor,
//             containerColor: containerColor,
//             decoration: decoration,
//             padding: padding,
//             message: message);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return setBubbleType();
//   }
// }
//
// upSide(
//     {Color? transFormColor,
//       String? message,
//       Color? containerColor,
//       Decoration? decoration,
//       TextStyle? messageStyle,
//       EdgeInsets? padding}) {
//   return Row(
//     mainAxisAlignment: MainAxisAlignment.end,
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Flexible(
//         child: Stack(
//           alignment: Alignment.bottomRight,
//           children: [
//             Container(
//               padding: padding ??
//                   const EdgeInsets.only(
//                       top: 14, bottom: 14.0, right: 25.0, left: 14.0),
//               constraints: const BoxConstraints(maxWidth: 300),
//               decoration: decoration ??
//                   BoxDecoration(
//                     color: containerColor ?? Colors.blue.shade700,
//                     borderRadius: const BorderRadius.only(
//                       topLeft: Radius.circular(18),
//                       bottomLeft: Radius.circular(18),
//                       bottomRight: Radius.circular(18),
//                     ),
//                   ),
//               child: Text(
//                 message.toString(),
//                 style: messageStyle ??
//                     const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(4.0),
//             //   child: Icon(
//             //     Icons.done_all,
//             //     size: 18,
//             //     color: seen == true ? Colors.black : Colors.white,
//             //   ),
//             // )
//           ],
//         ),
//       ),
//       CustomPaint(painter: CustomShape(transFormColor ?? Colors.blue.shade700)),
//     ],
//   );
// }
//
// bottomSide(
//     {Color? transFormColor,
//       String? message,
//       Color? containerColor,
//       Decoration? decoration,
//       TextStyle? messageStyle,
//       EdgeInsets? padding}) {
//   return Column(
//     mainAxisSize: MainAxisSize.min,
//     mainAxisAlignment: MainAxisAlignment.end,
//     crossAxisAlignment: CrossAxisAlignment.end,
//     children: [
//       Flexible(
//         child: Container(
//           padding: padding ??
//               const EdgeInsets.only(
//                   top: 14, bottom: 14.0, right: 25.0, left: 14.0),
//           constraints: const BoxConstraints(maxWidth: 300),
//           decoration: decoration ??
//               BoxDecoration(
//                 color: containerColor ?? Colors.blue.shade700,
//                 borderRadius: const BorderRadius.only(
//                   topLeft: Radius.circular(18),
//                   topRight: Radius.circular(18),
//                   bottomLeft: Radius.circular(18),
//                   // bottomRight: Radius.circular(18),
//                 ),
//               ),
//           child: Text(
//             message.toString(),
//             style: messageStyle ??
//                 const TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//       CustomPaint(
//           painter: CustomReverseShape(transFormColor ?? Colors.blue.shade700)),
//     ],
//   );
// }
//
// enum BubbleType { type1, type2 }
