import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/entry_screen.dart';
import 'package:flutter_projects/screens/signin_screen.dart';
import 'package:flutter_projects/screens/signup_screen.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, this.buttonText, this.textColor});
  final String? buttonText;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (e)=> const EntryScreen(),
            ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(30.0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
      
          child: Text(buttonText!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: textColor!
            )
          )),
    );
  }
}
