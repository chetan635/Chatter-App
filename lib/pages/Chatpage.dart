import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:google_fonts/google_fonts.dart';

class Chatpage extends StatefulWidget {
  @override
  _ChatpageState createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  var data;
  var Other_User_name;
  var Other_User_uid;
  var my_User_uid;
  var my_User_photo;
  var About;
  var chat="";
  final nameHolder = TextEditingController();
  var gg,gg1,gg2,gg3;

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    setState(() {
      gg=snapShot.data()["name"];
      gg1=snapShot.data()["about"];
      gg2=snapShot.data()["photo_url"];
      gg3=snapShot.data()["status"];
    });
  }
  var other_user_status;
//  void vvv5() async{
//    final User user = FirebaseAuth.instance.currentUser;
//    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${Other_User_uid}").get();
//
//    setState(() {
//      other_user_status=snapShot.data()["status"];
//    });
//  }


  void Delete(var timestamp){
    showDialog(
      context: this.context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete message?"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 15,),
              InkWell(
                  onTap: ()async{
                    await databaseReference.collection("messages").doc("${user.uid}").collection("$Other_User_uid").doc("$timestamp").delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for me",style: GoogleFonts.stylish(fontSize: 20),),
                  )
              ),
              SizedBox(height: 15,),
              InkWell(
                  onTap: (){
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Cancel",style: GoogleFonts.stylish(fontSize: 20),),
                  )
              ),
              SizedBox(height: 15,),
              InkWell(
                  onTap: ()async{
                    await databaseReference.collection("messages").doc("$Other_User_uid").collection("${user.uid}").doc("$timestamp").delete();
                    await databaseReference.collection("messages").doc("${user.uid}").collection("$Other_User_uid").doc("$timestamp").delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete for everyone",style: GoogleFonts.stylish(fontSize: 20),),
                  )
              ),
            ],
          ),

        ),
      ),
    );
  }
  void Delete2(var timestamp){
    showDialog(
      context: this.context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete message from $Other_User_name ?"),
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
                    await databaseReference.collection("messages").doc("${user.uid}").collection("$Other_User_uid").doc("$timestamp").delete();
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


  clearTextInput(){

    nameHolder.clear();

  }




  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  void Chat_messages(var chat, var other_id,var timestamp) async {
    final snapShot = await FirebaseFirestore.instance.collection('friends').doc("$other_id").collection("dost").doc("${user.uid}").get();
    final snapShot1 = await FirebaseFirestore.instance.collection('friends').doc("${user.uid}").collection("dost").doc("$other_id").get();


    if(chat==""){
      return;
    }
    await databaseReference.collection("messages")
        .doc("${user.uid}")
        .collection("${other_id}")
        .doc("${timestamp}")
        .set({
      'message': "${chat}",
      'status': "From_Me",
      'time': "${timestamp}",

    });
    if(!snapShot.exists || !snapShot1.exists){
      try{
        await databaseReference.collection("friends")
            .doc("${user.uid}")
            .collection("dost")
            .doc("${Other_User_uid}")
            .set({
          'name': "${Other_User_name}",
          'about': "${About}",
          'photo_url': "${my_User_photo}",
          'user_id': "${Other_User_uid}",
          'msg_count': 0,

        });
        await databaseReference.collection("friends")
            .doc("${Other_User_uid}")
            .collection("dost")
            .doc("${user.uid}")
            .set({
          'name': "${gg}",
          'about': "${gg1}",
          'photo_url': "${gg2}",
          'user_id': "${user.uid}",
          'msg_count': 0,

        });
      }catch(e){

      }
    }


    await databaseReference.collection("messages")
        .doc("${Other_User_uid}")
        .collection("${user.uid}")
        .doc("${timestamp}")
        .set({
      'message': "${chat}",
      'status': "From_Other",
      'time': "${timestamp}",

    });
  }
  var apple="";
  bool theame=true;
  Color a=Colors.grey[900];
  Color b=Colors.black;

  void vvv2() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('theame').doc("${user.uid}").get();

    setState(() {
      theame=snapShot.data()["theame"];
    });
    if(theame==true){
      setState(() {
        apple="assects/chatapp.jpg";
      });
    }
    else{
      setState(() {
        apple="assects/back2.jpg";
      });
    }
  }


  bool toggle=true;
  var Time;
  var Hour;
  var Minute;




  void timetodaily(var i){
    i=int.parse(i);
    Time=DateTime.fromMicrosecondsSinceEpoch(i,isUtc: false);
    Hour=Time.hour;
    Minute=Time.minute;
    if(Minute.toString().length==1){
      Minute="0$Minute";
    }

  }


  void msg_count()async{
    var count;
    final snapShot = await FirebaseFirestore.instance.collection('friends').doc("${Other_User_uid}").collection("dost").doc("${user.uid}").get();

      count=snapShot.data()["msg_count"];
      count+=1;


    await databaseReference.collection("friends")
        .doc("${Other_User_uid}")
        .collection("dost")
        .doc("${user.uid}")
        .update({
      'name': "${gg}",
      'about': "${gg1}",
      'photo_url': "${gg2}",
      'user_id': "${user.uid}",
      'msg_count': count,

    });


  }

   Future<bool> msg_to_zero()async{
    await databaseReference.collection("friends")
        .doc("${user.uid}")
        .collection("dost")
        .doc("${Other_User_uid}")
        .update({
      'msg_count': 0,

    });
    return true;
  }
  var apple5;




  @override
  void initState() {
    // TODO: implement initState
    vvv();
    vvv2();
//    vvv5();

  }




  @override
  Widget build(BuildContext context) {
    data=ModalRoute.of(context).settings.arguments;
    Other_User_name =data['name'];
    Other_User_uid =data['user_id'];
    my_User_uid =data['my_id'];
    my_User_photo =data['photo'];
    About =data['About'];
    print(my_User_uid);


    return WillPopScope(
      onWillPop: msg_to_zero,
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: AppBar(
          leading: IconButton(
            iconSize: 20,
              icon: Icon(FontAwesomeIcons.arrowLeft,),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: InkWell(
            onTap: (){
                Navigator.pushNamed(context, '/Other_Profile',arguments: {
                  'name' : Other_User_name,
                  'about' : About,
                  'photo_url' : my_User_photo,
                }

                );
            },
            child: Container(
              child: Row(
                children: [
                  CircleAvatar(
                    radius:24,
                    backgroundImage: NetworkImage(my_User_photo),
                  ),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("$Other_User_name",style: GoogleFonts.zillaSlab(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance.collection('users').doc('$Other_User_uid').snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              DocumentSnapshot documentSnapshot=snapshot.data;
                              if(documentSnapshot["status"].toString()=="true"){
                                apple5="online";
                              }
                              else{
                                apple5="";
                              }
                              return Text("$apple5",style: GoogleFonts.zillaSlab(fontSize: 16,fontWeight: FontWeight.bold,color: Colors.grey[100]),);
                            }
                            else{
//                  print('test phrase');
                              return SizedBox();
                            }

                          }
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
          toolbarHeight: 70,
          backgroundColor: Colors.blueGrey[900],
          elevation: 0.0,
        ),

        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image:  AssetImage(apple),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Container(
                height: 690,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  reverse: true,
                  children: [
                    Column(
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("messages").doc("${user.uid}").collection("$Other_User_uid").snapshots(),
                          builder: (context,snapshot){
                            if(snapshot.hasData){
                              return ListView.builder(
                                  physics: BouncingScrollPhysics(),

                                  shrinkWrap: true,
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context,index){
                                    DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
                                    if(documentSnapshot["status"]=="From_Me")
                                    {
                                      toggle=true;
                                    }
                                    else{
                                      toggle=false;
                                    }
                                    timetodaily(documentSnapshot["time"]);
                                    return  toggle ? Padding(
                                      padding: const EdgeInsets.only(right:15.0),
                                      child: InkWell(
                                        onLongPress: (){
                                            Delete(documentSnapshot["time"]);
                                        },
                                        child: Bubble(
                                          margin: BubbleEdges.only(top: 10),
                                          alignment: Alignment.topRight,
                                          nipWidth: 10,
                                          nipHeight: 15,
                                          nip: BubbleNip.rightTop,
                                          color: Colors.cyan[100],
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(5.0),
                                                  child: Text(documentSnapshot["message"], textAlign: TextAlign.right,style: GoogleFonts.stylish(fontSize: 23,color: theame?b:a),),
                                                ),
                                                Text("$Hour:$Minute", textAlign: TextAlign.right,style: GoogleFonts.stylish(fontSize: 14,color: theame?b:a),),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ) :
                                    Padding(
                                      padding: const EdgeInsets.only(left:15.0),
                                      child: InkWell(
                                        onLongPress: (){
                                            Delete2(documentSnapshot["time"]);
                                        },
                                        child: Bubble(
                                          margin: BubbleEdges.only(top: 10),
                                          alignment: Alignment.topLeft,
                                          nipWidth: 10,
                                          nipHeight: 15,
                                          nip: BubbleNip.leftTop,
                                          color:Colors.amber[300],
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child:  Column(
                                          children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: Text(documentSnapshot["message"], textAlign: TextAlign.right,style: GoogleFonts.stylish(fontSize: 23),),
                                                  ),
                                                  Text("$Hour:$Minute", textAlign: TextAlign.right,style: GoogleFonts.stylish(fontSize: 14),),
                                          ],
                                        ),
                                          ),
                                        ),
                                      ),
                                    )
                                    ;


                                  }

                              );
                            }
                            if (!snapshot.hasData){
                              print('test phrase');
                              return Text("Loading.....");
                            }

                          },

                        ),
                        SizedBox(height: 70,),
                      ],
                    ),

                  ],
                ),
              ),
              Stack(
                  children:[
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Row(
                        children: [
                          Card(
                            elevation: 20,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(55.0),
                            ),
                            child: new ConstrainedBox(
                              constraints: new BoxConstraints(
                                minWidth: 200,
                                maxWidth: 310,
                                minHeight: 25.0,
                                maxHeight: 150.0,
                              ),
                              child: new Scrollbar(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: new TextField(
                                    controller: nameHolder,
                                    cursorColor: Colors.red,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: null,
//              controller: tc,
//              _handleSubmitted : null,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                          top: 2.0,
                                          left: 13.0,
                                          right: 13.0,
                                          bottom: 2.0),
                                      hintText: "Type your message",
                                      hintStyle: TextStyle(
                                        color:Colors.grey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Chat_messages(nameHolder.text,Other_User_uid,DateTime.now().microsecondsSinceEpoch);
                              clearTextInput();
                              msg_count();
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(40))),
                              color: Colors.blueGrey,
                              child: Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Icon(Icons.send,size: 32,color: Colors.white,),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ]
              ),
            ],
          ),
        ),


      ),
    );
  }
}
