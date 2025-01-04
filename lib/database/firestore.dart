import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreDatabase {
  //current user
  User? user = FirebaseAuth.instance.currentUser;
  //collection posts
  final CollectionReference posts =
      FirebaseFirestore.instance.collection('Posts');
  //post a message
Future<void> addPost(String message) async {
    await posts.add({
      'message': message,
      'userEmail': user!.email,
      'createdAt': Timestamp.now(),
    });
  }
  //read posts from database
  Stream<QuerySnapshot> getPostsStream() {
    final postsStream = FirebaseFirestore.instance
        .collection('Posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
    return postsStream;
  }
}
