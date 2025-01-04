import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycommunity/components/my_drawer.dart';
import 'package:mycommunity/components/my_list_tile.dart';
import 'package:mycommunity/components/my_post_button.dart';
import 'package:mycommunity/components/my_textfield.dart';
import 'package:mycommunity/database/firestore.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // Firestore access
  final FirestoreDatabase database = FirestoreDatabase();

  // TextEditingController for the textfield
  final TextEditingController newPostController = TextEditingController();

  // Post message
  void postMessage() {
    if (newPostController.text.isNotEmpty) {
      String message = newPostController.text;
      database.addPost(message);
      // Clear controller
      newPostController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        title: const Text("W A L L "),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          // TextField box for user input
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    hintText: "What's on your mind?",
                    obscureText: false,
                    controller: newPostController,
                  ),
                ),
//post button
                const SizedBox(width: 10),
                PostButton(
                  onTap: postMessage,
                ),
              ],
            ),
          ),

          // Posts
          StreamBuilder(
            stream: database.getPostsStream(),
            builder: (context, snapshot) {
              //show loading circle
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              //get all posts
              final posts = snapshot.data!.docs;

              //no data
              if (snapshot.data == null || posts.isEmpty) {
                return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(25),
                      child: Text("No posts yet!")),
                );
              }

              //return list of posts
              return Expanded(
                child: ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      //get each post
                      final post = posts[index];
                      //get data from every post
                      String message = post['message'];
                      String userEmail = post['userEmail'];
                      Timestamp createdAt = post['createdAt'];
                      //return as a list tile
                      return MyListTile(title: message, subtitle: userEmail);
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
