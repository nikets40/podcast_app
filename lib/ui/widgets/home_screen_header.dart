import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HomeScreenHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String profilePicture = "https://www.upwork.com/profile-portraits/c18aTgsD4ldg98sgSCbHGEZ53W-11uhG7XwstGAQbi0C-RPwq203-DqFtGvecm3pqM";
    return  SliverAppBar(
      pinned: true,
      brightness: Brightness.light,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: false,
        titlePadding: EdgeInsets.all(20),
        title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Welcome Niket",
              style: TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            CircleAvatar(
              radius: 15,
              backgroundImage: CachedNetworkImageProvider(profilePicture),
            ),
          ],
        ),
      ),
    );
  }
}
