import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';

class Other_Profile extends StatefulWidget {
  @override
  _Other_ProfileState createState() => _Other_ProfileState();
}

class _Other_ProfileState extends State<Other_Profile> {
  var data;
  var name;
  var about;
  var photo;
  @override
  Widget build(BuildContext context) {

    data=ModalRoute.of(context).settings.arguments;
    name =data['name'];
    about =data['about'];
    photo =data['photo_url'];

    return Scaffold(
      appBar:AppBar(
        leading: IconButton(
            iconSize: 20,
            icon: Icon(FontAwesomeIcons.arrowLeft,),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Container(
          child: Row(
            children: [
              Text("$name",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
            ],
          ),
        ),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 370,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(photo),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.blueGrey[900],
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Card(
                    color: Colors.cyan[100],
                    elevation: 20,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Name",style: GoogleFonts.oswald(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$name",style: GoogleFonts.oswald(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            ),
                          ],
                        ),
                      ))
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Container(
                color: Colors.blueGrey[900],
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Card(
                    color: Colors.indigo[200],
                    elevation: 20,
                      child: Center(child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("About $name",style: GoogleFonts.oswald(fontSize: 27,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("$about",style: GoogleFonts.oswald(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
                            ),
                          ],
                        ),
                      ))
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
