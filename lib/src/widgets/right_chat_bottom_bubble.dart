// import 'package:flutter/material.dart';
// import 'custom_painter.dart';
//
// class RightChatBottomBubble extends StatelessWidget {
//   final String? message;
//   final Color? transFormColor;
//   final Color? containerColor;
//   final Decoration? decoration;
//   final TextStyle? messageStyle;
//   final EdgeInsets? padding;
//
//   const RightChatBottomBubble(
//       {Key? key,
//       this.message,
//       this.transFormColor,
//       this.containerColor,
//       this.decoration,
//       this.messageStyle,
//       this.padding})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Flexible(
//           child: Container(
//             padding: padding ??
//                 const EdgeInsets.only(
//                     top: 14, bottom: 14.0, right: 25.0, left: 14.0),
//             constraints: const BoxConstraints(maxWidth: 300),
//             decoration: decoration ??
//                 BoxDecoration(
//                   color: containerColor ?? Colors.blue.shade700,
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(18),
//                     topRight: Radius.circular(18),
//                     bottomLeft: Radius.circular(18),
//                     // bottomRight: Radius.circular(18),
//                   ),
//                 ),
//             child: Text(
//               message.toString(),
//               style: messageStyle ??
//                   const TextStyle(color: Colors.white, fontSize: 20),
//             ),
//           ),
//         ),
//         CustomPaint(
//             painter:
//                 CustomReverseShape(transFormColor ?? Colors.blue.shade700)),
//       ],
//     );
//   }
// }
