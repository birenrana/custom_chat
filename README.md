<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

TODO: Put a short description of the package here that helps potential users
know whether this package might be useful for them.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
const like = 'sample';
```

## Additional information

=>  One To One Chat Function :
1) can you use Above Function like
getImage, uploadImage, getVideo, uploadVideo, generateThumbnail,
sendAudioMsg, uploadAudio, selectFile, uploadDocument, sendDocumentMsg, sendContactNumberMsg => Use OneToOneDocumentField.function name & pass required field
(Example: OneToOneDocumentField.uploadImage).

2) can you use Above Function like
   sendMessage, messageField (Ui), leftChatBubble(Ui), rightChatBubble(Ui),
   deleteMessage,  updateMessage, seenChatList, setOnlineStatus, isTypingStatus => Use OneToOneMessageField.function name & pass required field
   (Example: OneToOneMessageField.leftChatBubble).

=> Group Chat Function:
1) can you use Above Function like
   getGroupImage, uploadGroupImage, getGroupVideo, uploadGroupVideo,
   generateThumbnail, getGroupProfileImage, uploadGroupProfileImage,
   sendContactNumberMsg, sendAudioMsg, uploadAudio, selectFile,
   uploadDocument, sendDocumentMsg => Use GroupDocumentField.function name & pass required field
   (Example: GroupDocumentField.sendAudioMsg).

2) can you use Above Function like
   groupMessageField, onGroupSendMessage, createGroup, groupLeftChatBubble, groupRightChatBubble, onAddMembers,
   removeMembers, onLeaveGroup, onGroupChatUpdateName,
   onGroupDelete, groupMessageDelete, groupMessageUpdate,
   groupChatSeenChatList => Use GroupMessageField.function name & pass required field
   (Example: GroupMessageField.createGroup).

=> Use Common Function in Both One to One Chat & Group Chat 
1) can you use Above Function Like
loginWithPhone, verifyOtp => Use CommonFunction.function name & pass required field
 (Example:CommonFunction.verifyOtp)