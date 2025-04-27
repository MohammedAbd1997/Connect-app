import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:voice_chat/Helper/Models/room_chat.dart';
import 'package:voice_chat/Screens/ChatScreen/view/chat_screen.dart';
import 'package:voice_chat/Utils/CustomWidgets/custom_text.dart';
import 'package:voice_chat/Utils/color_constant.dart';
import 'package:voice_chat/Utils/images_constant.dart';

import '../controller/main_controller.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(builder: (con) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => con.showAddRoomDialog(),
          backgroundColor: AppColor.primary,
          child: Image.asset(
            Images.addM,
            scale: 5,
          ),
        ),
        appBar: AppBar(
          title: CustomText(
            "Chats rooms",
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.primary,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: InkWell(
                onTap: () => con.signOut(),
                child: const Icon(
                  Icons.logout,
                  size: 20,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder<List<Map>>(
          stream: con.getRoomsStream(),
          builder: (context, snapshot) {
            // if (snapshot.connectionState == ConnectionState.waiting) {
            //   return const Center(child: CircularProgressIndicator());
            // }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No rooms available'));
            }

            final rooms = snapshot.data!
                .map((roomData) => RoomChat.fromMap(roomData, roomData['id']))
                .toList();

            return ListView.separated(
              itemCount: rooms.length,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              itemBuilder: (context, index) {
                final room = rooms[index];
                return Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: .2),
                        borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          room.name,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primary,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CustomText(
                                  'Created at: ${DateFormat("y-MMM-dd hh:mm aa").format(DateTime.fromMillisecondsSinceEpoch(room.createdAt))}'),
                            ),
                            room.members.containsKey("currentUserId")
                                ? CustomText('Joined')
                                : ElevatedButton(
                                    onPressed: () async {
                                      Get.to(() => ChatScreen(
                                            callId: room.id,
                                            roomName: room.name,
                                          ));
                                    },
                                    child: CustomText(
                                      'Join',
                                      color: AppColor.primary,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ));
              },
              separatorBuilder: (_, i) => SizedBox(
                height: 15.h,
              ),
            );
          },
        ),
      );
    });
  }
}
