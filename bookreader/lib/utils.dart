import 'package:flutter/material.dart';
import 'package:challenge_me/book.dart' ;

void showText({@required BuildContext context,
  @required String message, Color backgroundColor}){

  Navigator.of(context).overlay.insert(
      OverlayEntry(
          builder: (BuildContext context) {
            return _ShowNotification(
              message: message,
              backgroundColor: backgroundColor ?? Colors.black,
            );
          }
      )
  ) ;

}
class _ShowNotification extends StatefulWidget {
  final String message ;
  final Color backgroundColor ;
  _ShowNotification({this.message, this.backgroundColor}) ;
  @override
  _ShowNotificationState createState() => _ShowNotificationState();
}
class _ShowNotificationState extends State<_ShowNotification>
    with SingleTickerProviderStateMixin {

  AnimationController _controller ;
  bool hide = false ;

  @override
  void initState(){
    super.initState() ;
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this ,
    ) ;
    //_animation = Tween<double>(begin:0, end:1).animate(_controller) ;
    _controller.addStatusListener((status) {
      if(status == AnimationStatus.completed){
        setState(() {
          hide = true ;
        });
      }
    }) ;
    _controller.forward() ;
  }

  @override
  void dispose(){
    _controller.dispose() ;
    super.dispose() ;
  }

  @override
  Widget build(BuildContext context) {
    return hide ? Container() : Container(
      alignment: Alignment.topCenter ,
      decoration: BoxDecoration(
        color: Colors.transparent ,
      ) ,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.6 ,
      ) ,
      child: Container(
        height: 40 ,
        width: MediaQuery.of(context).size.width*0.5 ,
        alignment: Alignment.center ,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: widget.backgroundColor ,
          border: Border.all(width: 0.5, color: Colors.white) ,
        ) ,
        padding: EdgeInsets.all(5) ,
        child: Text(widget.message, style:Theme.of(context).textTheme.
        bodyText2.copyWith(color: Colors.white)) ,
      ),
    ) ;
  }
}

void showReadProgress({@required BuildContext context,
  @required String message, Color backgroundColor}){

  Navigator.of(context).overlay.insert(
      OverlayEntry(
          builder: (BuildContext context) {
            return _ReadBar(
              message: message,
              backgroundColor: backgroundColor ?? Colors.black,
            );
          }
      )
  ) ;

}
class _ReadBar extends StatefulWidget {
  final String message ;
  final Color backgroundColor ;
  _ReadBar({this.message, this.backgroundColor}) ;
  @override
  _ReadBarState createState() => _ReadBarState();
}
class _ReadBarState extends State<_ReadBar>{

  bool hide = false ;

  @override
  void initState(){
    super.initState() ;
  }

  @override
  void dispose(){
    super.dispose() ;
  }

  @override
  Widget build(BuildContext context) {
    return hide ? Container() : Container(
      alignment: Alignment.topCenter ,
      decoration: BoxDecoration(
        color: Colors.transparent ,
      ) ,
      /*padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height*0.6 ,
      ) ,*/
      child: Container(
        height: AppBar().preferredSize.height + 30 ,
        width: MediaQuery.of(context).size.width ,
        alignment: Alignment.center ,
        decoration: BoxDecoration(
          color: widget.backgroundColor ,
        ) ,
        padding: EdgeInsets.all(5) ,
        child: Text(widget.message, style:Theme.of(context).textTheme.
        bodyText2.copyWith(color: Colors.white)) ,
      ),
    ) ;
  }
}
