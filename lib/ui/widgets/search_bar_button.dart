import 'package:flutter/material.dart';
import 'package:podcast_app/ui/screens/search_view.dart';

class SearchHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreenView()));
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: Colors.black12, width: 2)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Search",
                style: TextStyle(fontSize: 16,color: Colors.black54),
              ),
              Icon(Icons.search,color: Colors.black54,)
            ],
          ),
        ),
      ),
    );
  }
}
