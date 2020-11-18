

import 'package:aeygiffarine/state/authen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Myservice extends StatefulWidget {
  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: buildDrawer(),
    );
  }

  Drawer buildDrawer() => Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.blue),
              child: ListTile(
                onTap: () async {
                  await Firebase.initializeApp().then((value) async {
                    await FirebaseAuth.instance
                        .signOut()
                        .then((value) => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Authen(),
                            ),
                            (route) => false));
                  });
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.red,
                  size: 50,
                ),
                title: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Out From Account For New Login',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
      );
}
