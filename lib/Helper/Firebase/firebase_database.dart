import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseHelper {
  FirebaseDatabaseHelper._();

  static FirebaseDatabaseHelper fdHelper = FirebaseDatabaseHelper._();

  FirebaseDatabase database = FirebaseDatabase.instance;
  final DatabaseReference chatRef = FirebaseDatabase.instance.ref('chat');

  Future<void> sendMessage(String message) async {
    try {
      await chatRef.push().set({
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      print('Message sent successfully');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
