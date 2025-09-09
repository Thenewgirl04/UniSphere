import 'package:flutter/material.dart';
import 'package:flutter_projects/theme/theme.dart';
import 'package:flutter_projects/widgets/custom_scaffold.dart';
import 'package:flutter_projects/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context){
    return CustomScaffold(
      child: Column(
        children: [
          Flexible(
            flex: 8,
              child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 0,
                          horizontal: 40.0,
                    ),
                  child:Center(child:RichText(
                    textAlign: TextAlign.left,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                        text: 'Welcome to \n',
                        style: TextStyle(
                          height: 3.0,
                          fontSize: 20.0,
                          fontFamily: "cursive",
                        ),
                        ),

                        TextSpan(
                          text: 'UNISPHERE\n',
                          style: TextStyle(
                            fontSize: 45.0,
                              fontWeight: FontWeight.w600

                          )
                        ),
                        TextSpan(
                            text: 'Your campus. Your events.\n',
                            style: TextStyle(
                                fontSize: 20.0,
                            ),
                        ),
                      ]
                    )
                  )),
              )),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child:WelcomeButton(
                buttonText: 'Next >',
                textColor: Colors.white,
              ),
            )
          ),
              ],
            ),
          );
  }
}