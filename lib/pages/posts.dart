import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';

class posts extends StatefulWidget {
  @override
  _postsState createState() => _postsState();
}

class _postsState extends State<posts> {
  File _image;
  var name;
  var photo_url;
  final User user = FirebaseAuth.instance.currentUser;
  final myController = TextEditingController();

  var desc;

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    setState(() {
      name=snapShot.data()["name"];
      photo_url=snapShot.data()["photo_url"];
    });
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }
  var link="gg";


  final databaseReference = FirebaseFirestore.instance;
  Future uploadPic(BuildContext context,var i,var time) async{

    String fileName = basename(_image.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image);
    TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() =>
        setState(() {
          print("Profile Picture uploaded");

          Scaffold.of(context).showSnackBar(SnackBar(content: Text('post added')));
        })
    );

    String url = (await firebaseStorageRef.getDownloadURL()).toString();
    print(url);
    if(url==""){
      return;
    }
    await databaseReference.collection("posts")
        .doc("for")
        .collection("all")
        .doc(time.toString())
        .set({
      'post_url':url,
      'photo_url':photo_url,
      'name':name,
      'id': user.uid,
      "desc":i,
      "time":time,
    });


  }


//  profileview(){
//    showDialog(
//      context: this.context,
//      builder: (ctx) => AlertDialog(
//        title: Text("Add Post"),
//        content: Container(
//          height: 170,
//          child: Column(
//            children: [
//              Container(
//                height: 120,
//                child: Card(
//                  shadowColor: Colors.blueGrey,
//                  elevation: 30.0,
//                  child: Padding(
//                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
//                    child: InkWell(
//                        onTap: (){
//                          getImage();
//                        },
//                        child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ_b4wi7ZqUCtuJWaHxFwEbI44bU2R-uUygA&usqp=CAU',fit: BoxFit.fill,)),
//                  ),
//                ),
//              ),
//              TextField(
//                controller: myController,
//                decoration: InputDecoration(
//
//                  hintText: "Enter Description",
//                  hintStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
//
//
//                ),
//
//              ),
//            ],
//          ),
//        ),
//        actions: <Widget>[
//          FlatButton(
//            onPressed: ()async {
//                uploadPic(this.context, myController.text,DateTime.now().microsecondsSinceEpoch);
//                Navigator.of(ctx).pop();
//            },
//            child: Text("Submit",style: GoogleFonts.stylish(fontSize: 20,color: Colors.grey[900]),),
//          ),
//        ],
//      ),
//    );
//  }

  clearTextInput(){

    myController.clear();

  }

  @override
  void initState() {
    // TODO: implement initState
    vvv();
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(FontAwesomeIcons.arrowLeft),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text("Posts",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
        toolbarHeight: 70,
        backgroundColor: Colors.blueGrey[900],
        elevation: 0.0,
      ),
        floatingActionButton: Builder(
          builder: (context) => InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(

                  content:Container(
                    height: 220,
                    child: Column(
                      children: [
                        InkWell(
                            onTap: (){
                              getImage();
                            },
                            child: Card(
                              shadowColor: Colors.blueGrey,
                                elevation: 30,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                  child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRJ_b4wi7ZqUCtuJWaHxFwEbI44bU2R-uUygA&usqp=CAU",height: 100,),
                                ))),

                        TextField(
                          controller: myController,

                          style: GoogleFonts.stylish(fontSize: 20,fontWeight: FontWeight.bold),
                          decoration: InputDecoration(

                            hintText: "Enter Description",
                            hintStyle: GoogleFonts.stylish(fontSize: 20,fontWeight: FontWeight.bold),


                          ),


                        ),
                        SizedBox(
                          height: 3,
                        ),
                        RaisedButton(
                          onPressed: (){
                            uploadPic(context, myController.text,DateTime.now().microsecondsSinceEpoch);
                            clearTextInput();
                            Navigator.of(ctx).pop();
                          },
                          color: Colors.blueGrey,child:Text("Add",style: GoogleFonts.stylish(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),),)
                      ],
                    ),
                  ),

                ),
              );
            },
            child:   Container(
              width: 70,
              height: 70,
              child: Card(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                      Radius.circular(90)),
                ),
                child: Icon(Icons.add,color: Colors.white,),
                color: Colors.blueGrey[500],
              ),
            ),
          ),
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
                                return Column(
                                  children: [
                                      Card(elevation: 0.0,
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
