import 'package:aeygiffarine/models/user_model.dart';
import 'package:aeygiffarine/state/authen.dart';
import 'package:aeygiffarine/state/information.dart';
import 'package:aeygiffarine/state/show_list_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Myservice extends StatefulWidget {
  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  UserModel userModel;
  Widget currentWidget = ShowListPost();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readData();
  }

  Future<Null> readData() async {
    await Firebase.initializeApp().then((value) async {
      await FirebaseAuth.instance.authStateChanges().listen((event) async {
        String uid = event.uid;
        print('uid ==>> $uid');
        await FirebaseFirestore.instance
            .collection('user')
            .doc(uid)
            .snapshots()
            .listen((event) {
          setState(() {
            userModel = UserModel.fromMap(event.data());
            print('name ==> ${userModel.name},email ==>> ${userModel.email}');
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: buildDrawer(),
      body: currentWidget,
    );
  }

  Drawer buildDrawer() => Drawer(
        child: Stack(
          children: [
            buildSignOut(),
            Column(
              children: [
                buildUserAccountsDrawerHeader(),
                buildListTileListPost(),
                Divider(),
                buildListTileListInformation(),
                Divider(
                  thickness: 3,
                  color: Colors.green,
                ),
              ],
            ),
          ],
        ),
      );

  ListTile buildListTileListPost() {
    return ListTile(
      leading: Icon(
        Icons.article,
        size: 36,
        color: Colors.blueGrey,
      ),
      title: Text('Show List Post'),
      subtitle: Text('Show Post All'),
      onTap: () {
        setState(() {
          currentWidget = ShowListPost();
        });
        Navigator.pop(context);
      },
    );
  }

  ListTile buildListTileListInformation() {
    return ListTile(
      leading: Icon(
        Icons.account_box,
        size: 36,
        color: Colors.green,
      ),
      title: Text('Information'),
      subtitle: Text('Display Information of user Logined'),
      onTap: () {
        setState(() {
          currentWidget = Information();
        });
        Navigator.pop(context);
      },
    );
  }

  UserAccountsDrawerHeader buildUserAccountsDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/wall.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      currentAccountPicture: Image.asset('images/logo.png'),
      accountName: Text(
        userModel == null ? 'Name' : userModel.name,
        style: TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        userModel == null ? 'Email' : userModel.email,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildSignOut() {
    return Column(
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
    );
  }
}
