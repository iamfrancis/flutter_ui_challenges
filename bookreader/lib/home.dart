import 'package:challenge_me/explore.dart';
import 'package:flutter/material.dart' ;

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    TextStyle styleOfText = Theme.of(context).textTheme.bodyText1.
    copyWith(color: Colors.white, fontSize: 30, letterSpacing: 1,
      fontWeight: FontWeight.w300 ,
    ) ;

    Widget textRow(){
      return Text("Discover.  Learn.  Elevate." , style: styleOfText)
        /*Row(
        crossAxisAlignment: CrossAxisAlignment.center ,
        mainAxisAlignment: MainAxisAlignment.center ,
        children: <Widget>[
          Text("Discover", style: styleOfText) ,
          Text(".", style: styleOfText) ,
          SizedBox(width: 10) ,
          Text("Learn", style: styleOfText) ,
          Text(".", style: styleOfText) ,
          SizedBox(width: 10) ,
          Text("Elevate", style: styleOfText) ,
          Text(".", style: styleOfText) ,
        ],
      )*/ ;
    }

    Widget exploreButton(){
      return FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40)) ,
        ) ,
        child: Text("START EXPLORING", style: Theme.of(context).textTheme.
        bodyText1.copyWith(color: Colors.blue[900], fontSize: 15,
          letterSpacing: 3, )) ,
        color: Colors.white ,
        textColor: Colors.blue[900] ,
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40) ,
        onPressed: (){
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 1500),
              pageBuilder: (_, __, ___) => Explore(),
            ),
          ) ;
        } ,
      ) ;
    }

    Widget heroColumn(){
      return Hero(
        tag: 'toExplore' ,
        child: Column(
          children: <Widget>[
            Icon(Icons.add_circle_outline,
                color: Colors.white, size: 50) ,
            SizedBox(height: 20) ,
            Center( child: textRow() ,) ,
          ],
        ),
      ) ;
    }

    return Scaffold(
      backgroundColor: Colors.blue[900].withOpacity(0.7) ,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          crossAxisAlignment: CrossAxisAlignment.center ,
          children: <Widget>[
            heroColumn() ,
            SizedBox(height: 30) ,
            exploreButton() ,
          ],
        ) ,
      ) ,
      bottomNavigationBar: Container(
        height: 50 ,
        child: Text("BY INVISION", textAlign: TextAlign.center,
            style: styleOfText.copyWith(fontSize: 12, fontWeight: FontWeight.w300)
        ) ,
      ) ,
    );
  }

}
