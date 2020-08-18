import 'package:challenge_me/read.dart';
import 'package:flutter/material.dart' ;
import 'package:challenge_me/book.dart' ;
import 'package:challenge_me/utils.dart' ;

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> with TickerProviderStateMixin{

  List<Book> books ;
  ScrollController booksScrollController ;
  AnimationController mainContentController ;
  double contentPadding ;
  bool hideFirstHero ;
  Color booksBackgroundColor = Colors.blue[900] ;
  double booksIndicatorValue ;

  double screenWidth(){
    return MediaQuery.of(context).size.width ;
  }

  @override
  void initState(){
    super.initState() ;
    books = _populateBooksList(length: 5) ;
    booksIndicatorValue = 1 / books.length ;
    booksScrollController = ScrollController() ;
    booksScrollController.addListener(() {
      double currentOffset = booksScrollController.offset ;
      double tabNumberDouble = currentOffset/(screenWidth()*0.8 + 15) ;
      int tabNumber = tabNumberDouble.round() + 1 ;
      setState(() {
        booksIndicatorValue = tabNumber / books.length ;
        booksBackgroundColor = books[tabNumber-1].color  ;
      });
    }) ;
    contentPadding = 600 ;
    mainContentController = AnimationController(
      vsync: this ,
      duration: Duration(milliseconds: 10) ,
    ) ;
    mainContentController.addStatusListener((status){
      if( mainContentController.status == AnimationStatus.completed ){
        mainContentController.reverse() ;
      }
    }) ;
    mainContentController.addListener((){
      double value = mainContentController.value ;
    }) ;
    mainContentController.reverseDuration = Duration(milliseconds: 1000) ;
    mainContentController.forward() ;
  }

  @override
  void dispose(){
    booksScrollController.dispose() ;
    mainContentController.dispose() ;
    super.dispose() ;
  }

  Widget topBar(){
    return Container(
      alignment: Alignment.topRight ,
      padding: EdgeInsets.fromLTRB(0,10,20,5) ,
      child: IconButton(
        icon: Icon(Icons.sort, color: Colors.white) ,
        onPressed: (){
          Navigator.of(context).pop() ;
        } ,
      ) ,
    ) ;
  }

  List<Widget> tabs(){
    return [
      Tab( text: 'BOOKS',) ,
      Tab( text: 'PODCAST',) ,
      Tab( text: 'WORKSHOPS',) ,
    ] ;
  }

  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width ;
    double screenHeight = MediaQuery.of(context).size.height ;

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
    Widget heroColumn(){
      return Hero(
        tag: 'toExplore' ,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.18 ,
          child: ListView(
            children: <Widget>[
              Icon(Icons.add_circle_outline ,
                  color: Colors.white, size: 50) ,
              SizedBox(height: 20) ,
              Center( child: textRow() ,) ,
              SizedBox(height: 10) ,
            ],
          ),
        ),
      ) ;
    }

    Widget bookTab({Book book}){
      return Container(
        width: screenWidth * 0.8 ,
        padding: EdgeInsets.all(10) ,
        margin: EdgeInsets.symmetric(horizontal:12, vertical:8) ,
        decoration: BoxDecoration(
          color: Colors.white ,
          borderRadius: BorderRadius.all(
            Radius.circular(20) ,
          ) ,
          boxShadow: [
            BoxShadow(offset: Offset(0,5),
                blurRadius:10, color: Colors.grey[500],)
          ] ,
        ) ,
        child: Column(
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: "${book.hashCode}",
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.teal ,
                    image: DecorationImage(
                      image: AssetImage(book.imageAsset) ,
                      fit: BoxFit.cover ,
                    ) ,
                    border: Border(
                      bottom: BorderSide(width:0.5, color:book.color) ,
                    ) ,
                  ),
                ),
              ) ,
            ) ,
            Container(
              padding: EdgeInsets.only(left: 10) ,
              height: screenHeight * 0.25 ,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start ,
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        showText(context: context, message: book.title,
                        backgroundColor: book.color) ;
                      } ,
                      child: Text( book.title , softWrap: true ,
                          overflow: TextOverflow.clip ,
                          style: Theme.of(context).
                            textTheme.headline4.copyWith(color: Colors.black,
                            fontWeight: FontWeight.w600, letterSpacing: 2,
                          ) ,
                      ),
                    ),
                  ) ,
                  SizedBox(height: 5) ,
                  Text("By ${book.author}", style: Theme.of(context).
                  textTheme.headline6.copyWith(color: Colors.black)) ,
                  SizedBox(height: 5) ,
                  FlatButton(
                    child: Text("READ BOOK",
                      style: Theme.of(context).textTheme.bodyText1.
                        copyWith(color:Colors.white, fontWeight:FontWeight.w300,
                          letterSpacing: 2)) ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)) ,
                    ) ,
                    padding: EdgeInsets.symmetric(vertical:5, horizontal:25) ,
                    color: book.color ?? Colors.blue[900],
                    textColor: Colors.white ,
                    onPressed: (){
                      //show duplicate hero column and navigate to page
                      /*Navigator.of(context).pushNamed('/read' ,
                          arguments: book) ;*/
                      print("${book.hashCode}") ;
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(milliseconds: 1000),
                          pageBuilder: (_, __, ___) => Read(currentBook: book),
                        ),
                      ) ;
                    } ,
                  ) ,
                ],
              ) ,
            ) ,
          ] ,
        ) ,
      ) ;
    }

    Widget bookCard(){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: books.length ,
              scrollDirection: Axis.horizontal ,
              shrinkWrap: true ,
              controller: booksScrollController ,
              itemBuilder: (context, index){
                if(index==1) books[index].color = Colors.red[900] ;
                return bookTab(
                  book: books[index] ,
                ) ;
              } ,
            ) ,
          ) ,
          SizedBox(height: 20) ,
          Row(
            children: <Widget>[
              SizedBox(width: 50) ,
              Expanded(
                child: Container(
                  height: 3 ,
                  child: LinearProgressIndicator(
                    value: booksIndicatorValue ,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        booksBackgroundColor) ,
                    backgroundColor: Colors.grey[300],
                  ),
                ),
              ) ,
              SizedBox(width: 50) ,
            ],
          ) ,
          SizedBox(height: 20) ,
        ],
      ) ;
    }

    Widget mainContent(){
      return Container(
        decoration: BoxDecoration(
          color: Colors.white ,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30) ,
            topRight: Radius.circular(30) ,
          ) ,
        ) ,
        child: DefaultTabController(
          length: 3 ,
          child: Scaffold(
            backgroundColor: Colors.transparent ,
            appBar: TabBar(
              labelStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize:18 , fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ) ,
              labelPadding: EdgeInsets.fromLTRB(20,20,20,0) ,
              isScrollable: true ,
              labelColor: Colors.black ,
              unselectedLabelColor: Colors.grey ,
              indicatorSize: TabBarIndicatorSize.label ,
              indicatorPadding: EdgeInsets.fromLTRB(10,0,0,0),
              indicator: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.blue[900], width:5)),
              ) ,
              tabs: tabs() ,
            ) ,
            body: Container(
              padding: EdgeInsets.fromLTRB(0,20,0,10) ,
              child: TabBarView(
                children: <Widget>[
                  bookCard() ,
                  Placeholder() ,
                  Placeholder() ,
                ],
              ) ,
            ) ,
          ),
        ),
      ) ;
    }

    return Scaffold(
      backgroundColor: booksBackgroundColor.withOpacity(0.7) ,
      body: Container(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(0,50,0,0),
              child: Container(
                child: heroColumn() ,
              ),
            ) ,
            AnimatedBuilder(
              animation: mainContentController ,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0,200,0,0) ,
                child: Container(
                  child: mainContent() ,
                ),
              ),
              builder: (context, child){
                return Transform.translate(
                  offset: Offset(0,(screenHeight-200)*mainContentController.value ) ,
                  child: child ,
                ) ;
              } ,
            ) ,
            Padding(
              padding: EdgeInsets.fromLTRB(0,10,0,0),
              child: Container(
                child: topBar() ,
              ),
            ) ,
          ],
        ) ,
      ) ,
      /*Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start ,
          children: <Widget>[
            SizedBox(height: 10) ,
            topBar() ,
            heroColumn() ,
            SizedBox(height: 15) ,
            Expanded(
              child: mainContent() ,
            ) ,
          ] ,
        ) ,
      ) ,*/
    ) ;
  }

  static List<Book> _populateBooksList({int length}){
    List<Book> returnedList = [] ;
    for(int i=0; i<length; i++){
      returnedList.add(Book()) ;
    }
    returnedList[0].color = Colors.blue[900] ;
    returnedList[0].baseColor = Colors.blue ;

    returnedList[1].color = Colors.red[900] ;
    returnedList[1].baseColor = Colors.red ;
    returnedList[1].title = "Colors.red[900]" ;

    returnedList[2].color = Colors.green[900] ;
    returnedList[2].baseColor = Colors.green ;
    returnedList[2].title = "The Richest Man in Babylon" ;

    returnedList[3].color = Colors.yellow[900] ;
    returnedList[3].baseColor = Colors.yellow ;

    returnedList[4].color = Colors.pink[900] ;
    returnedList[4].baseColor = Colors.pink ;
    return returnedList ;
  }
}
