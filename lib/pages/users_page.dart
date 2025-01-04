import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mycommunity/components/my_back_button.dart';
import 'package:mycommunity/components/my_list_tile.dart';
import 'package:mycommunity/helper/helper_funcyions.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("users").snapshots(),
          builder: (context ,snapshot){
            //errors
            if (snapshot.hasError){
              displayMessageToUser(" Something wrong ", context);
            }

            //show loading
            if (snapshot.connectionState == ConnectionState.waiting){
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.data  == null){
              return const Center(
                child: Text("No data"),
              );
            }
            //get all users
            final users = snapshot.data!.docs;

            return Column(
              children: [
                //back button
                const Padding(
                  padding: EdgeInsets.only(
                    top:50.0,
                    left: 25.0,
                  ),
                  child:
                  Row(
                    children: [
                      MyBackButton(),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                //list of users in app
                Expanded(child:
                ListView.builder(
                    itemCount: users.length,
                    padding: const EdgeInsets.all(0),
                    itemBuilder: (context,index) {
                      //get individual user
                      final user = users[index];

                      String username = user["username"];
                      String email = user["email"];
                      
                      return MyListTile(title: username, subtitle: email);
                    },
                ),
                ),
              ],

            );

          },
          ),
    );
  }
}
