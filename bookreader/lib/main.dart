import 'package:challenge_me/read.dart';
import 'package:flutter/material.dart';
import 'package:challenge_me/home.dart' ;
import 'package:challenge_me/explore.dart' ;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false ,
      /*navigatorObservers: [
        HeroController(createRectTween: (Rect begin, Rect end){
          return Tween<Rect>() ;
        }) ,
      ] ,*/
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/home' ,
      onGenerateRoute: (RouteSettings settings){
        if( settings.name == '/home'){
          return MaterialPageRoute<Home>(
            settings: settings,
            builder: (context) {
              return Home() ;
            },
          ) ;
        }/* else if( settings.name == '/explore'){
          return MaterialPageRoute<Explore>(
            settings: settings,
            builder: (context) {
              return Explore() ;
            },
          ) ;
        } else if( settings.name == '/read'){
          return MaterialPageRoute<Explore>(
            settings: settings,
            builder: (context) {
              return Read(currentBook: settings.arguments) ;
            },
          ) ;
        }*/ else {
          return  MaterialPageRoute<Scaffold>(
            settings: settings,
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: Text("Undefined Route") ,
                ) ,
              ) ;
            },
          );
        }
      } ,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Container() ;
  }
}
