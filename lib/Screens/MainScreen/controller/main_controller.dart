import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voice_chat/Helper/SharedPreferance/shared_preferance.dart';
import 'package:voice_chat/Screens/AuthScreen/ui/sign_in_screen.dart';

import '../../../Helper/Models/room_chat.dart';
import '../ui/widgets/add_room_dialog.dart';

class MainController extends GetxController {
  List<RoomChat> roomChats = [];

  TextEditingController roomNameController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  validate() {
    bool isSuccess = formKey.currentState!.validate();
    return isSuccess;
  }

  showAddRoomDialog() {
    Get.dialog(AddRoomDialog());
  }

  String? nullValidator(String? value) {
    final RegExp REGEX_EMOJI = RegExp(
        r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

    if (value!.isEmpty) {
      return 'Required Field';
    }

    return null;
  }

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;

  // Create a new room
  Future<void> createRoom() async {
    if (validate()) {
      isLoading = true;
      update();
      try {
        // 1. Check if room name already exists
        final roomName = roomNameController.text.trim();
        final roomsSnapshot = await _dbRef
            .child('rooms')
            .orderByChild('name')
            .equalTo(roomName)
            .once();

        if (roomsSnapshot.snapshot.exists) {
          // Room with this name already exists
          Get.snackbar(
            'Error',
            'A room with this name already exists',
            backgroundColor: Colors.red,
          );
          isLoading = false;
          update();
          return;
        }
        final newRoomRef = _dbRef.child('rooms').push();
        await newRoomRef.set({
          'name': roomNameController.text,
// 'createdBy': createdBy,
          'createdAt': ServerValue.timestamp
// 'members': {createdBy: true}
        });
        Get.back();
        roomNameController.clear();
      } catch (e) {
        throw Exception('Failed to create room: $e');
      }
      isLoading = false;
      update();
    }
  }

  signOut() async {
    await FirebaseAuth.instance.signOut();
    SpHelper.spHelper.setUserId("");
    Get.offAll(() => SignInScreen());
  }

// Get all rooms stream
  Stream<List<Map>> getRoomsStream() {
    return _dbRef.child('rooms').onValue.map((event) {
      final Map<dynamic, dynamic>? rooms = event.snapshot.value as Map?;
      if (rooms == null) return [];

      return rooms.entries.map((entry) {
        return {
          'id': entry.key,
          ...(entry.value as Map),
        };
      }).toList();
    });
  }
}
