
import 'package:flutter/material.dart';
import 'package:login/pages/Chatpage.dart';
import 'package:login/pages/Login.dart';
import 'package:login/pages/Other_Profile.dart';
import 'package:login/pages/SignUp.dart';
import 'package:login/pages/addpost.dart';
import 'package:login/pages/friends.dart';
import 'package:login/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:login/pages/myposts.dart';
import 'package:login/pages/posts.dart';
import 'package:login/pages/settings.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/pages/auth_service.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        Provider<Auth_serve>(
          create: (_)=>Auth_serve(FirebaseAuth.instance),
        ),
        StreamProvider(create: (context)=> context.read<Auth_serve>().authStateChanges)
      ],
      child: MaterialApp(
        initialRoute: '/aoth',
        routes: {

          '/Login': (context) => Login(),
          '/SignUp': (context) => SignUp(),
          '/home': (context) => Home(),
          '/settings': (context) => ProfilePage(),
          '/Chatpage': (context) => Chatpage(),
          '/Other_Profile': (context) => Other_Profile(),
          '/friends': (context) => friends(),
          "/aoth": (context)=>Aoth(),
          "/posts": (context)=>posts(),
          "/myposts": (context)=>myposts(),
//          "/addpost": (context)=>addpost(),

      //'/home':(context)=>home(),


    },
  )));
}
class Aoth extends StatelessWidget {

  const Aoth({
    Key key,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if(firebaseUser != null){
      return Home();
    }

    else{
      return Login();
    }
  }
}