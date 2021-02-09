import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:intl/intl.dart';

class Utils{

  static Utils instance = new Utils();

  parsedHtml({@required String htmlString}){
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  formattedReleasedDate({ @required int milliseconds}){
    var time =  DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return DateFormat('MMM dd, yyyy').format(time);
  }
  formattedTime(int seconds){
    var time = Duration(seconds: seconds);
    return "${time.inMinutes.remainder(60)} min ${(time.inSeconds.remainder(60))} sec";
  }

}