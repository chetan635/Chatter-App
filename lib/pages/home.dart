import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'SignUp.dart';
import 'friends.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({this.page})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) =>
    page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) =>
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
  );
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final databaseReference = FirebaseFirestore.instance;
  final User user = FirebaseAuth.instance.currentUser;

  void about(var j){
    try{
      var apple=j.substring(0,30);
      return(apple);
    }catch(e){
      return(j);
    }
  }
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
    }
  }



  void createuser() async{
    final User user = FirebaseAuth.instance.currentUser;


    final snapShot = await FirebaseFirestore.instance.collection('users').doc("${user.uid}").get();

    if (!snapShot.exists){
      try{
        var name="";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Name please!!!",style: GoogleFonts.zillaSlab(fontSize: 23,fontWeight: FontWeight.bold,color: Colors.red[400]),)),
                content: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(

                            onFieldSubmitted: (value){
                              setState(() {
                                name=value;
                              });
                            },
                            style: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),
                            decoration: InputDecoration(

                              hintText: "Enter Your Name..",
                              hintStyle: GoogleFonts.zillaSlab(fontSize: 20,fontWeight: FontWeight.bold),


                            ),


                          ),
                        ),
                      ),
                    ),
                    Container(height:46,width: 220,child: RaisedButton(color: Colors.blue,child:Text("Submit",style: GoogleFonts.aladin(fontWeight: FontWeight.bold,letterSpacing: 1,fontSize: 20),),
                        onPressed:() async{
                          await databaseReference.collection("users")
                              .doc("${user.uid}")
                              .set({
                            'name': "$name",
                            'about': "Hey ,I am using Chatter",
                            'user_id': "${user.uid}",
                            'photo_url': "https://www.seekpng.com/png/detail/72-729756_how-to-add-a-new-user-to-your.png",
                            'status': false,

                          });
                          Navigator.of(context).pop();
                        }))
                  ],
                ),

              );
            });


      }
      catch(e){
        print(e);

      }


    }

    else{
      print("user already there boy");
    }

  }
  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,

            colors: [
              Colors.blueGrey[500],
              Colors.blueGrey[100],
              Colors.blueGrey[900],
              Colors.blueGrey[700],
            ],
          ),
        ),
        child: new AlertDialog(
          title: new Text('Are you sure?',style: GoogleFonts.stylish(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.blueGrey[900]),),
          content: new Text('Do you want to exit an App',style: GoogleFonts.stylish(fontSize: 20,color: Colors.blueGrey[700]),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO",style: GoogleFonts.stylish(fontSize: 20,color: Colors.green[900]),),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () async{
                  await databaseReference.collection("users")
                      .doc("${user.uid}")
                      .update({
                    'status': false,

                  });
                  Navigator.of(context).pop(true);},
                child: Text("YES",style: GoogleFonts.stylish(fontSize: 20,color: Colors.green[900]),),
              ),
            ),
          ],
        ),
      ),
    ) ??
        false;
  }

  profileview(var photo,var name){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text("$name",style: GoogleFonts.stylish(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blueGrey),)),
        content: Container(
          height: 300,
          decoration: BoxDecoration(
              image: DecorationImage( image: NetworkImage('$photo'),fit: BoxFit.cover)),
        ),
      ),
    );
  }
  bool toggle=true;
  bool theame=true;
  Color a= Colors.grey[200];
  Color b=Colors.blueGrey[900];
  Color d=Colors.white;
  Color e=Colors.black;
  Color bottom1=Colors.blueGrey[700];
  Color bottom2=Colors.blueGrey[100];

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('theame').doc("${user.uid}").get();

    setState(() {
      theame=snapShot.data()["theame"];
    });
  }

  void changestatus() async{
    await databaseReference.collection("users")
        .doc("${user.uid}")
        .update({
      'status': true,

    });
  }
  bool other_user_status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    createuser();
    vvv();
    changestatus();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assects/star.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Row(
              children: [
                Image.asset("assects/logo.jpg",height: 42,),
                SizedBox(width: 8,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("CHaTtTeR",style: GoogleFonts.stylish(fontSize: 32,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
                    Text("All Users",style: GoogleFonts.stylish(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
                  ],
                ),
              ],
            ),
            toolbarHeight: 100,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: <Widget>[
              PopupMenuButton<String>(
                onSelected: handleClick,
                itemBuilder: (BuildContext context) {
                  return {'Logout', 'Settings'}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],

          ),
          body:   SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Card(
              color: theame?a:b,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30)),
              ),
              child: Container(

                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Card(
                      color: theame?a:b,
                      elevation: 0,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),

                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context,index){
                                  DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
                                  if(documentSnapshot["user_id"]=="${user.uid}"){
                                    toggle=true;
                                  }
                                  else{
                                    toggle=false;
                                  }
                                    return toggle? Text("") : Column(
                                      children: [
                                        Card(
                                          elevation: 0,
                                          color: theame?a:b,
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                    onTap: () async {



                                                      Navigator.pushNamed(context, "/Chatpage",arguments: {
                                                        'name':documentSnapshot["name"],
                                                        'user_id':documentSnapshot["user_id"],
                                                        'my_id':user.uid,
                                                        'photo':documentSnapshot["photo_url"],
                                                        'About':documentSnapshot["about"],

                                                      });
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(5.0),
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap:(){
                                                              profileview(documentSnapshot["photo_url"], documentSnapshot["name"]);
                                                            },
                                                            child: CircleAvatar(
                                                              radius:28,
                                                              backgroundImage: NetworkImage(documentSnapshot["photo_url"]),
                                                            ),
                                                          ),
                                                          SizedBox(width: 15,),
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(documentSnapshot["name"],style: GoogleFonts.stylish(fontSize: 25,color: theame?b:a,),),
                                                              Padding(
                                                                padding: const EdgeInsets.all(2.0),
                                                                child: Text(documentSnapshot["about"],style: GoogleFonts.zillaSlab(fontSize: 16,color: theame?b:a,),),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )),

                                              ],

                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(77,0,12,0),
                                          child: Divider(
                                            color: theame?b:a,
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
                    SizedBox(height: 600,)
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: 2,
            backgroundColor: theame?bottom2:bottom1,
            items: [
              BottomNavigationBarItem(
                icon: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, SlideRightRoute(page: friends()));
                    },
                    child: new Icon(Icons.people,)),
                title: new Text('Friends',
                  style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold),),
              ),
               BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushNamed(context, "/posts");
                },child: new Icon(Icons.photo)),
                title: new Text('Posts',style: GoogleFonts.stylish(fontSize: 15,fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushNamed(context, "/home_Weather");
                },child: new Icon(Icons.chat,color: theame?e:d,)),
                title: new Text('All Users',style: GoogleFonts.zillaSlab(fontSize: 15,fontWeight: FontWeight.bold,color: theame?e:d)),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
