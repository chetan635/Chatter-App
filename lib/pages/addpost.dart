import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';

class addpost extends StatefulWidget {
  @override
  _addpostState createState() => _addpostState();
}

class _addpostState extends State<addpost> {

  var name;
  var photo_url;
  var id;

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    setState(() {
      name=snapShot.data()["name"];
      photo_url=snapShot.data()["photo_url"];
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Settings",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),
    );
  }
}
