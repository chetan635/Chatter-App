import 'dart:convert';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';


import 'SignUp.dart';
import 'home.dart';


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

class friends extends StatefulWidget {
  @override
  _friendsState createState() => _friendsState();
}

class _friendsState extends State<friends> {

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

  Color a= Colors.grey[200];
  Color b=Colors.blueGrey[900];
  Color d=Colors.white;
  Color e=Colors.black;
  bool Colorstoggle=true;
  bool fonttoggle=true;
  bool other_user_status;

  Color bottom1=Colors.blueGrey[700];
  Color bottom2=Colors.blueGrey[100];
  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        signOut();
        break;
      case 'Settings':
        Navigator.pushNamed(context, '/settings');
        break;
      case 'Change\nTheame':
        change_theame();
        vvv();
        Colorstoggle=!Colorstoggle;
        break;
      case 'Posts':
        Navigator.pushNamed(context, '/myposts');
        break;
    }
  }

//  for do you want to exit
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
          content: new Text('Do you want to exit an App',style: GoogleFonts.stylish(fontSize: 20,color: Colors.blueGrey[900]),),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO",style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.green[900]),),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: new GestureDetector(
                onTap: () async {
                  await databaseReference.collection("users")
                      .doc("${user.uid}")
                      .update({
                    'status': false,

                  });
                  Navigator.of(context).pop(true);},
                child: Text("YES",style: GoogleFonts.zillaSlab(fontSize: 20,color: Colors.green[900]),),
              ),
            ),
          ],
        ),
      ),
    ) ??
        false;
  }

  profileview(var photo,var name,var id){
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(child: Text("$name",style: GoogleFonts.stylish(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.blueGrey),)),
        content: Container(
          height: 350,
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage( image: NetworkImage('$photo'),fit: BoxFit.cover)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Delete Friend",style: GoogleFonts.stylish(fontSize: 20,fontWeight: FontWeight.bold),),
                    InkWell(
                        onTap: (){
                          Delete_Friend(name, id);
                        },
                        child: Icon(Icons.delete))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  bool theame=true;

  void vvv() async{
    final User user = FirebaseAuth.instance.currentUser;
    final snapShot = await FirebaseFirestore.instance.collection('theame').doc("${user.uid}").get();

    setState(() {
      theame=snapShot.data()["theame"];
    });
  }

  void change_theame()async{
    try{
      await databaseReference.collection("theame")
          .doc("${user.uid}")
          .set({
        'theame': Colorstoggle,

      });
    }catch(e){
      await databaseReference.collection("theame")
          .doc("${user.uid}")
          .update({
        'theame': !Colorstoggle,

      });
    }

  }

  void Delete_Friend(var a ,var b){
    showDialog(
      context: this.context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.only(top:210.0,bottom: 210),
        child: AlertDialog(
          title: Text("Delete Friend ${a} ?"),
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
                    await databaseReference.collection("friends").doc("${user.uid}").collection("dost").doc("${b}").delete();
                    Navigator.of(ctx).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text("Delete Friend"),
                  )
              ),

            ],
          ),

        ),
      ),
    );
  }
  bool toggle2=false;







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vvv();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:  AssetImage("assects/star.jpg"),
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
                    Text("Friends",style: GoogleFonts.stylish(fontSize: 19,fontWeight: FontWeight.bold,color: Colors.grey[100]),),
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
                  return {'Logout', 'Settings',"Change\nTheame","Posts"}.map((String choice) {
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
                        stream: FirebaseFirestore.instance.collection('friends').doc("${user.uid}").collection('dost').snapshots(),
                        builder: (context,snapshot){
                          if(snapshot.hasData){
                            return ListView.builder(
                                physics: BouncingScrollPhysics(),

                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context,index){
                                  DocumentSnapshot documentSnapshot=snapshot.data.documents[index];
                                  if(documentSnapshot["msg_count"]==0){
                                    toggle2=true;
                                  }
                                  else{
                                    toggle2=false;
                                  }
                                  return Column(
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
                                                            profileview(documentSnapshot["photo_url"],documentSnapshot['name'],documentSnapshot['user_id']);
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
                                                            Text(documentSnapshot["name"],style: GoogleFonts.stylish(fontSize: 25,color: theame?e:d),),
                                                            Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Text(documentSnapshot["about"],style: GoogleFonts.zillaSlab(fontSize: 16,color: theame?e:d),),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(width: 40,),
                                                        Container(
                                                          width: 34,
                                                          height: 34,
                                                          child: toggle2?Text(""):Card(
                                                            color: Colors.amber,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.all(
                                                                  Radius.circular(30)),
                                                            ),
                                                            child: Center(child: Text(documentSnapshot["msg_count"].toString(),style: GoogleFonts.stylish(color: Colors.grey[900],fontSize: 18),)),
                                                          ),
                                                        )
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
            currentIndex: 0,
            backgroundColor: theame?bottom2:bottom1,
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.people,color: theame?e:d,size: 25,),
                title: new Text('Friends',
                  style: GoogleFonts.stylish(fontSize: 15,fontWeight: FontWeight.bold,color: theame?e:d),),
              ),
              BottomNavigationBarItem(
                icon: InkWell(onTap: (){
                  Navigator.pushNamed(context, "/posts");
                },child: new Icon(Icons.photo)),
                title: new Text('Posts',style: GoogleFonts.stylish(fontSize: 15,fontWeight: FontWeight.bold)),
              ),
              BottomNavigationBarItem(
                icon: InkWell(
                    onTap: (){
                      Navigator.pushReplacement(context, SlideRightRoute(page: Home()));
                    },
                    child: new Icon(Icons.chat)),
                title: new Text('All Users',style: GoogleFonts.stylish(fontSize: 15,fontWeight: FontWeight.bold)),
              ),

            ],
          ),
        ),
      ),
    );
  }
  Future signOut() async{
    try{
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, "/Login");
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
}
