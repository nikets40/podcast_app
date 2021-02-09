import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:podcast_app/core/models/GenresList.dart';
import 'package:podcast_app/core/networking/api_provider.dart';
import 'package:podcast_app/ui/screens/search_view.dart';
import 'package:podcast_app/ui/widgets/best_of_genre_widget.dart';
import 'package:podcast_app/ui/widgets/bottom_mini_player.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.red,
        backgroundColor: Color(0xff121212),
        bottomNavigationBar: BottomMiniPLayer(),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchScreenView()));
                }),

            IconButton(
                icon: Icon(Icons.exit_to_app),
                onPressed: () async{
                  await FirebaseAuth.instance.signOut();
                  Phoenix.rebirth(context);

                })
          ],
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image.asset("assets/icons/icon_foreground.png",height: kToolbarHeight*0.45,),
              SizedBox(
                width: 15,
              ),
              Text(
                "PodNix",
                textScaleFactor: 1.1,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                FutureBuilder<GenresList>(
                    // future: ApiProvider().getGenres(showTopLevelGenresOnly: true),
                    future: ApiProvider()
                        .getGenresFromLocalStorage(context: context),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        var genresList = snapshot.data;
                        genresList.genres.retainWhere(
                            (element) => element.name == "Technology");
                        return ListView.separated(
                          separatorBuilder: (ctx, ind) => SizedBox(
                            height: 15,
                          ),
                          padding: EdgeInsets.only(top: 0),
                          // itemCount: genresList.genres.length,
                          itemCount: 10,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return BestOfGenresListing(
                              genre: genresList.genres[0],
                            );
                          },
                        );
                      }
                      return CircularProgressIndicator();
                    }),
                SizedBox(height: MediaQuery.of(context).size.height*0.2,)
              ],
            ),
          ),
        ));
  }
}
