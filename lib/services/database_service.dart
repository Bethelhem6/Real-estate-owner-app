import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:upload_property/models/chat_user.dart';





class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  var user = FirebaseAuth.instance.currentUser!;

  Future updateUserData(
      String email, String name, String phonenumber, String image) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final chatUser = ChatUser(
        id: user.uid,
        name: name,
        email: email,
        about: "Hey there!",
        image: image,
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '');

    return await userCollection.doc(uid).set(chatUser.toJson());
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
}
