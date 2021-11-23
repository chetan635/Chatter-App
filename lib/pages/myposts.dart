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

class myposts extends StatefulWidget {


  @override
  _mypostsState createState() => _mypostsState();
}

class _mypostsState extends State<myposts> {

  var name;
  var photo_url;
  final User user = FirebaseAuth.instance.currentUser;
  final myController = TextEditingController();

  var desc;

  final databaseReference = FirebaseFirestore.instance;


  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    setState(() {
      name=snapShot.data()["name"];
      photo_url=snapShot.data()["photo_url"];
    });
  }
  bool toggle=true;
   var p;
  deletepost(var p,var x) async{


    showDialog(
      context: this.context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Deletepost ?"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: (){
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Cancel"),
                  )
              ),
              InkWell(
                  onTap: ()async{
                    await databaseReference.collection("posts").doc("for").collection("all").doc(x.toString()).delete();
//                    Reference j= await FirebaseStorage.instance.ref(p);
//                    j.delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for me"),
                  )
              ),

            ],
          ),

        ),
      ),
    );


  }


  @override
  void setState(fn) {
    // TODO: implement setState
    vvv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("My Posts",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          color:Colors.blueGrey[100],

          child: Container(

            child: Column(
              children: [
//                  SizedBox(height: 10,),
                Container(
                  color: Colors.grey[900],

                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('posts').doc("for").collection('all').snapshots(),
                    builder: (context,snapshot){
                      if(snapshot.hasData){
                        return ListView.builder(
                            physics: BouncingScrollPhysics(),

                            shrinkWrap: true,
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (context,index){
                              DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
                              if(user.uid==documentSnapshot['id']){
                                toggle=false;
                              }
                              else{
                                toggle=true;
                              }
                              return toggle?SizedBox(height: 0.0,): Column(
                                children: [
                                  InkWell(
                                    onLongPress:(){
                                      deletepost(documentSnapshot['post_url'],documentSnapshot['time']);
                                    },
                                    child: Card(elevation: 0.0,
                                      color:Colors.grey[800],
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 28,
                                                    backgroundImage: NetworkImage(
                                                        documentSnapshot["photo_url"]),
                                                  ),
                                                  SizedBox(width: 20,),
                                                  Text(documentSnapshot['name'],style: GoogleFonts.stylish(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.white),)
                                                ],
                                              ),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                  image: DecorationImage( image: NetworkImage(documentSnapshot["post_url"]),fit: BoxFit.fill)),
                                              height: 370,

                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(documentSnapshot['desc'],style: GoogleFonts.stylish(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(12,20,12,20),
                                    child: Divider(
                                      color: Colors.white,
                                      thickness:1.3,
                                    ),
                                  ),
                                ],
                              );


                            }

                        );
                      }
                      if (!snapshot.hasData){
                        print('test phrase');
                        return Text("Loading.....");
                      }

                    },

                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
