import 'package:flutter/material.dart';
import '../theme/theme.dart';

class DashboardScaffold extends StatelessWidget {
  final Widget child;

  const DashboardScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body:
      Stack(
        children: [
          Positioned.fill(
      child:
      Image.asset(
        'assets/images/newbg.png',
        fit: BoxFit.cover,
      ),
    ),
    SafeArea(
        child: SizedBox.expand( // ✅ add this to constrain the child properly
    child: child,),
    ),
    ],
      ),
      );
  }
}
