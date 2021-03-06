import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:http/http.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  var gg=" ";
  var gg1=" ";
  var gg2=" ";
  var About;
  var Name;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vvv();
  }
  final User user = FirebaseAuth.instance.currentUser;
  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    setState(() {
      gg=snapShot.data()["name"];
      gg1=snapShot.data()["about"];
      gg2=snapShot.data()["photo_url"];
    });
  }


  @override
  Widget build(BuildContext context) {

    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }
    var link="gg";


    final databaseReference = FirebaseFirestore.instance;
    Future uploadPic(BuildContext context) async{

      String fileName = basename(_image.path);
      Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = firebaseStorageRef.putFile(_image);
      TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() =>
          setState(() {
            print("Profile Picture uploaded");

            Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
          })
      );

      String url = (await firebaseStorageRef.getDownloadURL()).toString();
      print(url);
      await databaseReference.collection("users")
          .doc("${user.uid}")
          .update({
        'photo_url':url,
      });


    }





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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Builder(
          builder: (context) =>  Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 94,
                        backgroundColor: Colors.blueGrey[500],
                        child: ClipOval(
                          child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image!=null)?Image.file(
                              _image,
                              fit: BoxFit.fill,
                            ):Image.network(
                              "$gg2",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60.0),
                      child: IconButton(
                        icon: Icon(
                          FontAwesomeIcons.camera,
                          size: 30.0,
                        ),
                        onPressed: () {
                          getImage();
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.0,
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.person,color: Colors.blueGrey[700],size: 39,),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Align(

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Name',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.zillaSlab(
                                          color: Colors.blueGrey[900], fontSize: 18.0)),
                                ),
                              ),
                              Align(

                                child: Padding(
                                  padding: const EdgeInsets.only(bottom:8.0),
                                  child: Text('$gg',
                                      textAlign: TextAlign.left,
                                      style: GoogleFonts.zillaSlab(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              Center(child: Text("This is not your Username or pin.\n This is your name on records"))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: InkWell(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("Change Name"),
                                    content: TextField(

                                      onSubmitted: (value){
                                        setState(() {
                                          Name=value;
                                        });

                                      },
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: ()async {
                                          await databaseReference.collection("users").doc("${user.uid}").update({"name":"$Name"});
                                          setState(() {
                                            gg=Name;
                                          });
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Submit"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                FontAwesomeIcons.pen,
                                color: Colors.blueGrey,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0,0,60,0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness:1.3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.info,color: Colors.blueGrey[700],size: 35),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Align(

                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('About me',
                                      style: GoogleFonts.zillaSlab(
                                          color: Colors.blueGrey[900], fontSize: 18.0)),
                                ),
                              ),
                              Align(

                                child: Text('$gg1',
                                    style: GoogleFonts.zillaSlab(
                                        color: Colors.black,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:20.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            child: InkWell(
                              onTap: (){
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text("About Me"),
                                    content: TextField(

                                      onSubmitted: (value){
                                        setState(() {
                                          About=value;
                                        });

                                      },
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        onPressed: ()async {
                                          await databaseReference.collection("users").doc("${user.uid}").update({"about":"$About"});
                                          setState(() {
                                            gg1=About;
                                          });
                                          Navigator.of(ctx).pop();
                                        },
                                        child: Text("Submit"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Icon(
                                FontAwesomeIcons.pen,
                                color: Colors.blueGrey,
                                size: 19,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0,0,60,0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness:1.3,
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(00.0),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 20, 20, 20),
                    child: Row(
                      children: <Widget>[

                        Icon(Icons.mail,color: Colors.blueGrey[700],size: 30),
                        SizedBox(width: 58,),
                        Text('Email',
                            style:
                            GoogleFonts.zillaSlab(color: Colors.blueGrey, fontSize: 18.0)),
                        SizedBox(width: 20.0),
                        Text('${user.email}',
                            style: GoogleFonts.zillaSlab(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0,0,60,0),
                  child: Divider(
                    color: Colors.grey[400],
                    thickness:1.3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      RaisedButton(
                        color: Color(0xff476cfb),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'Cancel',
                          style: GoogleFonts.zillaSlab(color: Colors.white, fontSize: 16.0),
                        ),
                      ),
                      RaisedButton(
                        color: Color(0xff476cfb),
                        onPressed: () {
                          uploadPic(context);
                        },

                        elevation: 4.0,
                        splashColor: Colors.blueGrey,
                        child: Text(
                          'Submit',
                          style: GoogleFonts.zillaSlab(color: Colors.white, fontSize: 16.0),
                        ),
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}