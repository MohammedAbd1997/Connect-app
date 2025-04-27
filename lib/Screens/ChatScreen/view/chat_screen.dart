import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/images_constant.dart';

import '../../../Helper/Models/audio_message.dart';
import '../../../Helper/SharedPreferance/shared_preferance.dart';
import '../../../Utils/color_constant.dart';
import '../controller/chat_controller.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.callId, required this.roomName});

  final String callId;
  final String roomName;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final controller = Get.put(VoiceChatController());

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    await controller.init();
    // Automatically join the call when screen loads
    await controller.joinCall(widget.callId);
  }

  @override
  void dispose() {
    controller.endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VoiceChatController>(builder: (con) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.roomName),
          actions: [],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StreamBuilder<List<Map>>(
                stream: con.getVoiceStream(widget.callId),
                builder: (context, snapshot) {
                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(''));
                  }
                  final voice = snapshot.data!
                      .map((roomData) =>
                          AudioMessage.fromMap(roomData, roomData['id']))
                      .toList();

                  return Expanded(
                    child: ListView.separated(
                      itemCount: voice.length,
                      reverse: true,
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 20.h),
                      itemBuilder: (context, index) {
                        final room = voice[index];
                        return room.sender.toString() ==
                                SpHelper.spHelper.getUserId().toString()
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width - 250,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // SizedBox(
                                    //   width: 5.w,
                                    // ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              130,
                                          child: ChatBubble(
                                            elevation: 0,
                                            backGroundColor: AppColor.primary,
                                            clipper: ChatBubbleClipper5(
                                              type: BubbleType.sendBubble,
                                            ),
                                            alignment: Alignment.topLeft,
                                            margin:
                                                const EdgeInsets.only(top: 15),
                                            child: IntrinsicWidth(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          con.playAudioChunks(
                                                              room.audioChunks);
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          size: 35,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                              Images.progress,
                                                              scale: 4)),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      CustomText(
                                                        con.formatDuration(
                                                            room.duration),
                                                        onTap: () {},
                                                        color: Colors.white,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Text(
                                          DateFormat('hh:mm aa', 'en_US')
                                              .format(DateTime(room.timestamp)
                                                  .toLocal()),
                                          style: TextStyle(fontSize: 10.sp),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 10.h),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CircleAvatar(
                                        radius: 20,
                                        child: CustomText( con.users.firstWhereOrNull((u) => u['id'] == room.sender)?["fullName"].toString().capitalizeFirst ?[0]??"" ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              130,
                                          child: ChatBubble(
                                            elevation: 0,
                                            alignment:
                                                Get.locale?.languageCode == "ar"
                                                    ? Alignment.topRight
                                                    : null,
                                            backGroundColor:
                                                Colors.grey.withOpacity(.3),
                                            clipper: ChatBubbleClipper5(
                                              type: BubbleType.receiverBubble,
                                            ),
                                            margin:
                                                const EdgeInsets.only(top: 15),
                                            child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          con.playAudioChunks(
                                                              room.audioChunks);
                                                        },
                                                        child: Icon(
                                                          Icons
                                                              .play_arrow_rounded,
                                                          size: 35,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        Images.progress,
                                                        scale: 4,
                                                        color: Colors.black,
                                                      )),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      CustomText(
                                                        con.formatDuration(
                                                            room.duration),
                                                        onTap: () {},
                                                        color: Colors.black,
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 7.h,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Text(
                                              DateFormat('hh:mm aa', 'en_US')
                                                  .format(
                                                      DateTime(room.timestamp)
                                                          .toLocal()),
                                              style: TextStyle(fontSize: 10.sp),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // SizedBox(
                                  //   width: 5.w,
                                  // ),

                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              );
                      },
                      separatorBuilder: (_, i) => SizedBox(
                        height: 15.h,
                      ),
                    ),
                  );
                },
              ),

              Container(
                height: 100.h,
                decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.3)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColor.primary,
                      child: IconButton(
                        iconSize: 35,
                        icon: Icon(
                          controller.isRecording ? Icons.mic : Icons.mic_off,
                          color: controller.isRecording
                              ? Colors.white
                              : Colors.white,
                        ),
                        onPressed: () async {
                          if (controller.isRecording) {
                            await controller.stopVoiceStream();
                          } else {
                            await controller.startVoiceStream();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: const Icon(
                          Icons.call_end,
                          size: 35,
                          color: Colors.white,
                        ),
                        onPressed: () => {controller.endCall(), Get.back()},
                      ),
                    ),
                  ],
                ),
              ),
              // CustomBotton(
              //   title: "start Call",
              //   onTap: () => controller.playVoice(),
              // )
            ],
          ),
        ),
      );
    });
  }
}
