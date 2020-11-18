

import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

double lat,lng;
@override
void  initState(){
  super.initState();
  findLatLng();
}

Future<Null> findLatLng()async{
  LocationData locationData = await findLocationData();
  setState(() {
    lat = locationData.latitude;
    lng = locationData.longitude;
    print('lat = $lat, lng = $lng');
  });
}

Future<LocationData> findLocationData()async{
  Location location =Location();
  try {
    return location.getLocation();
  } catch (e) {
    return null;
  }
}

  Container buildName() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.face),
          labelText: 'Name :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_box),
          labelText: 'User :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock),
          labelText: 'Password :',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              children: [
                buildName(),
                buildUser(),
                buildPassword(),
                buildMap(context),
              ],
            ),
          ),
          buildElevatedButton(),
        ],
      ),
    );
  }

  Expanded buildMap(BuildContext context) {
    return Expanded(
                child: Container(
                  color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                  child: Text('This is Map'),
                ),
              );
  }

  Column buildElevatedButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(Icons.cloud_upload),
            label: Text('Register'),
          ),
        ),
      ],
    );
  }
}
