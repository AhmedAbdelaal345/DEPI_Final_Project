import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2C2F48),
      child: ListView(
        children: const [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF5AC7C7)),
            child: Center(
              child: Text("Menu",
                  style: TextStyle(color: Colors.white, fontSize: 22)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text("Home", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Profile", style: TextStyle(color: Colors.white)),
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Settings", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
