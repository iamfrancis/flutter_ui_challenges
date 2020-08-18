import 'package:flutter/cupertino.dart' ;
import 'package:flutter/material.dart' ;
import 'package:challenge_me/book.dart' ;
import 'package:challenge_me/utils.dart' ;

class Read extends StatefulWidget {

  final Book currentBook ;
  Read({this.currentBook}) ;

  @override
  _ReadState createState() => _ReadState();

}

class _ReadState extends State<Read> with SingleTickerProviderStateMixin {

  ScrollController mainScroller ;
  bool showTransitionIcon ;
  bool showAppBarTransitionIcon ;
  double transitionBottomPadding ;
  bool showStackProgressBar ;
  double scrollProgressValue ;

  double bottomStackControllerValue = 0.2 ;
  double centerIconMoveY ;

  final double transitionIconSize = 50 ;

  @override
  void initState(){
    super.initState() ;
    showTransitionIcon = false ;
    showAppBarTransitionIcon = false ;
    showStackProgressBar = false ;
    transitionBottomPadding = 20 ;
    mainScroller = ScrollController() ;
    mainScroller.addListener(() {
      double position = mainScroller.offset ;
      setState((){
        scrollProgressValue = position/mainScroller.position.maxScrollExtent ;
        bottomStackControllerValue = startValue(position) ;
        transitionBottomPadding = setTransitionBottomPadding(position) ;
      }) ;
      if( position == 0 ){
        setState((){ showStackProgressBar = false ;
        showTransitionIcon = false ; showAppBarTransitionIcon = false ;}) ;
      } else if( position >
          expandedHeight() - _progressStackHeight() + (transitionIconSize/2) ){
        showStackProgressBar = true ;
        showTransitionIcon = false ;
        showAppBarTransitionIcon = true ;
      } else {
        setState((){ showStackProgressBar = true ;
        showTransitionIcon = true ; showAppBarTransitionIcon = false ;}) ;
      }
    }) ;
  }

  @override
  void dispose(){
    mainScroller.dispose() ;
    super.dispose() ;
  }

  double screenHeight(){
    return MediaQuery.of(context).size.height ;
  }

  double expandedHeight(){
    return MediaQuery.of(context).size.height * 0.45 ;
  }

  double _progressStackHeight(){
    return AppBar().preferredSize.height + 30 ;
  }

  double startValue(double position){
    return position/( expandedHeight() - _progressStackHeight() ) ;
  }

  double setTransitionBottomPadding(double position){
      return screenHeight() - (expandedHeight()+transitionIconSize+position) ;
  }

  Widget centerWidget(){
    return Container(
      alignment: Alignment.center ,
      padding: EdgeInsets.only(top: 18) ,
      child: Hero(
        tag: 'toExplore' ,
        child: Container(
          height: transitionIconSize ,
          width: transitionIconSize ,
          decoration: BoxDecoration(
            color: widget.currentBook.color ,
            shape: BoxShape.circle ,
          ) ,
          alignment: Alignment.center ,
          child: Icon(Icons.add_circle_outline,
            color: Colors.white, size: 30) ,
        ),
      ) ,
    ) ;
  }

  Widget transition(){
    return Container(
      alignment: Alignment.bottomCenter ,
      child: Hero(
        tag: 'toExplore' ,
        child: Container(
          height: transitionIconSize ,
          width: transitionIconSize ,
          decoration: BoxDecoration(
            color: widget.currentBook.color ,
            shape: BoxShape.circle ,
          ) ,
          alignment: Alignment.center ,
          child: Icon(Icons.add_circle_outline ,
              color: Colors.white, size: 30) ,
        ),
      ) ,
    ) ;
  }

  Widget goBack(){
    return GestureDetector(
      child: Icon(Icons.arrow_back_ios, color: Colors.white) ,
      onTap: (){
        Navigator.of(context).pop() ;
      } ,
    ) ;
  }

  Widget menu(){
    return GestureDetector(
      child: Icon(Icons.sort, color: Colors.white) ,
      onTap: (){
        //Navigator.of(context).pop() ;
      } ,
    ) ;
  }

  Widget progressStack(){
    return Container(
      height: _progressStackHeight() ,
      child: Stack(
        children: <Widget>[
          Container(
            height: _progressStackHeight() ,
            child: LinearProgressIndicator(
              value: bottomStackControllerValue ,
              valueColor: AlwaysStoppedAnimation<Color>(
                  widget.currentBook.baseColor
              ) ,
              backgroundColor: Colors.transparent ,
            ),
          ),
          Container(
            height: _progressStackHeight() ,
            child: LinearProgressIndicator(
              value: scrollProgressValue ,
              valueColor: AlwaysStoppedAnimation<Color>(
                 widget.currentBook.color
              ) ,
              backgroundColor: Colors.transparent ,
            ),
          ) ,
          Container(
            alignment: Alignment.centerLeft ,
            padding: EdgeInsets.fromLTRB(17,25.5,5,5) ,
            child: goBack() ,
          ) ,
          Container(
            alignment: Alignment.centerRight ,
            padding: EdgeInsets.fromLTRB(17,25.5,29.5,5) ,
            child: menu() ,
          ) ,
          showAppBarTransitionIcon ? centerWidget():Container() ,
        ],
      ) ,
    ) ;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height ;
    double bookPictureHeight = expandedHeight() ;

    Widget bookPicture(){
      return Container(
        color: Colors.white ,
        child: Stack(
          children: <Widget>[
            Hero(
              tag: "${widget.currentBook.hashCode}" ,
              child: Container(
                height: bookPictureHeight ,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.currentBook.imageAsset) ,
                    fit: BoxFit.cover ,
                  ) ,
                ) ,
              ) ,
            ) ,
            (!showTransitionIcon) ? transition() : SizedBox() ,
          ],
        ),
      ) ;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white ,
      ) ,
      child: Container(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              controller: mainScroller ,
              slivers: <Widget>[
                SliverAppBar(
                  leading: goBack() ,//SizedBox() ,
                  //title: showAppBarTransitionIcon ? centerWidget():Container() ,
                  centerTitle: true ,
                  actions: <Widget>[ Icon(Icons.sort), SizedBox(width:30) ],
                  backgroundColor: Colors.transparent ,
                  pinned: true ,
                  expandedHeight: bookPictureHeight,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.all(0) ,
                    background: bookPicture() ,
                  ) ,
                ) ,
                SliverList(
                  delegate: SliverChildListDelegate([
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center ,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children: <Widget>[
                        Container( color: Colors.white , height: 10 , ) ,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white ,
                          ) ,
                          child: Text("INVISION PRESENTS", textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.black, letterSpacing:1.5, fontSize: 10,
                                fontWeight: FontWeight.w500,
                              )),
                        ) ,
                        Container( color: Colors.white , height: 10 , ) ,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white ,
                          ) ,
                          child: Text(widget.currentBook.title, textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6.copyWith(
                                color: Colors.black, letterSpacing:3, fontSize: 38,
                                fontWeight: FontWeight.w700,
                              )),
                        ) ,
                        Container( color: Colors.white , height: 10 , ) ,
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white ,
                          ) ,
                          child: Text("By ${widget.currentBook.author}",
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyText1.copyWith(
                                color: Colors.black, letterSpacing:1.5, fontSize: 15,
                                fontWeight: FontWeight.w500,
                              )),
                        ) ,
                        Container( color: Colors.white , height: 20 , ) ,
                        SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical:5, horizontal:15) ,
                            child: Container(
                              color: Colors.white ,
                              child: Text.rich(
                                TextSpan(
                                    text: widget.currentBook.bookText ,
                                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                                        fontSize: 20, fontWeight: FontWeight.w400,
                                        letterSpacing:1
                                    )
                                ),
                                textAlign: TextAlign.left ,
                                strutStyle: StrutStyle(height: 2.0),
                              ) ,
                            ),
                          ) ,
                        ) ,
                      ],
                    ) ,
                  ],) ,
                ) ,
              ],
            ) ,
            showStackProgressBar ? Container(
              alignment: Alignment.topCenter ,
              child: progressStack() ,
            ) : SizedBox() ,
            showTransitionIcon ? Container(
              alignment: Alignment.topCenter ,
              padding: EdgeInsets.only(
                  bottom: screenHeight - (transitionBottomPadding) ,
              ) ,
              child: transition() ,
            ) : SizedBox() ,
          ],
        ) ,
      ) ,
    ) ;
  }
}
