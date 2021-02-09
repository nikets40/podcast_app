import 'package:flutter/material.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final TextEditingController searchTextController;
  SearchAppBar({Key key,this.searchTextController})
      : preferredSize = Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  _SearchAppBarState createState() => _SearchAppBarState();

  @override
  final Size preferredSize;
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xfff3f3f4),
      title: TextField(
        onChanged: (val){

          if(val.length<2)
            setState(()=>null);
        },
        controller: widget.searchTextController,
        style: TextStyle(fontSize: 18),
        decoration: InputDecoration.collapsed(hintText: "Search"),
      ),
      actions: [Visibility(
        visible: widget.searchTextController.text.length>0,
          child: IconButton(icon: Icon(Icons.close), onPressed: () {setState(() {
            widget.searchTextController.clear();
          });}))],
    );
  }
}
