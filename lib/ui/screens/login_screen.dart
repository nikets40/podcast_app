import 'package:flutter/material.dart';
import 'package:podcast_app/core/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121212),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: MediaQuery.of(context).size.width * 0.6,
              width: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  color: Color(0xff212121),
                  borderRadius: BorderRadius.circular(10000),
                  image: DecorationImage(
                      image: AssetImage("assets/icons/icon_front.png"))),
            ),
            SizedBox(
              height: 25,
            ),
            Spacer(),
            SizedBox(height: 30,),
            LoginButton(
               imageIcon: Image.asset("assets/icons/google.png",height: 25,),
              label: "Continue with Google",
              onPressed:
                 AuthService.instance.signInWithGoogle,
            ),
            SizedBox(height: 10,),
            LoginButton(
              imageIcon: Image.asset("assets/icons/fb.png",height: 25,color: Color(0xff4267B2),),
              label: "Continue with Facebook",
              onPressed: AuthService.instance.signInWithFacebook,
            ),
            Spacer()
          ],
        ),
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  final Widget imageIcon;
  final String label;
  final VoidCallback onPressed;


  LoginButton({@required this.imageIcon, @required this.label, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.95,
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:18.0,horizontal: 20),
          child: Row(
            children: [
              imageIcon,
              Spacer(),
              Text(label,style: TextStyle(fontSize: 20),),
              Spacer()
            ],
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          side: BorderSide(width: 2,color: Color(0xff535353)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))
        ),
      ),
    );
  }
}





















