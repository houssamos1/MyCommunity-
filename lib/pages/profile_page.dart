import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mycommunity/components/my_back_button.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  //curent logged in user
  final User? currentUser = FirebaseAuth.instance.currentUser;

  //future to fetch user details
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserDetails() async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser!.email)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: getUserDetails(),
          builder: (context, snapshot) {
            //loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            //errror
            else if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
            //data
            else if (snapshot.hasData) {
              Map<String, dynamic>? user = snapshot.data!.data()!;

              return Center(
                child: Column(
                  children: [
                    //back button
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 50.0,
                        left: 25.0,
                      ),
                      child: Row(
                        children: [
                          MyBackButton(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    //profile image
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      padding: const EdgeInsets.all(25),
                      child: const Icon(
                        Icons.person,
                        size: 80,
                      ),
                    ),
                    const SizedBox(height: 25),
                    //username
                    Text(user["username"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        )),
                    const SizedBox(height: 10),
                    //email
                    Text(user["email"],
                        style: const TextStyle(
                          color: Colors.grey,
                        )),
                  ],
                ),
              );
            } else {
              return Text(" No data");
            }
          }),
    );
  }
}
