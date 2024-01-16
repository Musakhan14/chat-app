import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  final String name;
  final String email;
  final String profilePictureUrl;

  const CustomDrawer({
  super.key,
  required this.name,
  required this.email,
  required this.profilePictureUrl,
});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  _handleSignOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirect to the login or home screen as needed.
    } catch (e) {
      print('Error signing out: $e');
    }
  }

@override
Widget build(BuildContext context) {
  return Drawer(
    backgroundColor: Colors.white,
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 150,
          color: Colors.pink[900], // Pink dark header color
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.profilePictureUrl),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                Text(
                  widget.email,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(
          color: Colors.grey, // Divider line color
          thickness: 2.0, // Divider line thickness
        ),
        ListTile(
          leading: const Icon(Icons.home),
          title: const Text(
            'Home',
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to the home screen
            Navigator.pop(context); // Close the drawer
            // Navigate to the home screen
            // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
        ),
        // Add more ListTile widgets for other options in the drawer
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text(
            'Settings',
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {
            // Handle navigation to the settings screen
            Navigator.pop(context); // Close the drawer
            // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
        ), ListTile(
          leading: const Icon(Icons.logout),
          title: const Text(
            'Log out',
            style: TextStyle(fontSize: 18),
          ),
          onTap: () {setState(() {

          });
            _handleSignOut();
          },
        ),
        // Add more menu items as needed
      ],
    ),
  );
}
}
