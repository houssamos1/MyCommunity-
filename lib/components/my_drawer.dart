import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  //logout user
  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            child: Icon(
              Icons.favorite,
              size: 50,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 25.0),

          // Home title
          _buildListTile(
            context,
            icon: Icons.home,
            text: "Home",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/home_page');
            },
          ),

          // Profile title
          _buildListTile(
            context,
            icon: Icons.person,
            text: "Profile",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/profile_page');
            },
          ),

          // Users title
          _buildListTile(
            context,
            icon: Icons.people,
            text: "Users",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/users_page');
            },
          ),

          // Settings title
          _buildListTile(
            context,
            icon: Icons.settings,
            text: "Settings",
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/settings');
            },
          ),

          // Logout title
          _buildListTile(
            context,
            icon: Icons.logout,
            text: "Logout",
            onTap: () {
              Navigator.pop(context);

              logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
      BuildContext context, {
        required IconData icon,
        required String text,
        required VoidCallback onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(
          text,
          style: TextStyle(fontSize: 16),
        ),
        onTap: onTap,
      ),
    );
  }
}
