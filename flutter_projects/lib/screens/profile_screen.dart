import 'package:flutter/material.dart';
import 'package:flutter_projects/theme/theme.dart';
import 'package:flutter_projects/widgets/Nots_tile.dart';
import 'package:flutter_projects/widgets/myeve_card.dart';
import 'package:flutter_projects/widgets/org_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My profile'),
        backgroundColor: lightColorScheme.primary,
        actions: [
          IconButton(onPressed: (){
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out')),);
          }, icon: const Icon(Icons.logout),
          tooltip: 'Log out',)
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/logou.png'),
              backgroundColor: Colors.grey,
            ),

            const Text(
              'Chinwe Onwuka',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),

            const Text(
              'CS Major, Class of 2028',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),

            ElevatedButton(onPressed: () {

            },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('My Organizations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ),
            const SizedBox(height: 10,),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  OrgCard(title: 'Black Student Union', imagePath: 'assets/images/logou.png'),
                  OrgCard(title: 'Techies Club', imagePath: 'assets/images/logou.png'),
                  OrgCard(title: 'Women in STEM', imagePath: 'assets/images/logou.png'),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'My Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10,),

        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child:
            Row(
              children: [
                MyeveCard(title: 'Tech Career Fair', date: 'June 28, 2025', ),
                MyeveCard(title: 'Tech Career Fair', date: 'June 28, 2025', ),
              ],
            ),
        ),
            const SizedBox(height: 30,),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Notifications',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10,),

            Column(
              children: [
                NotsTile(icon: Icons.notifications_active, message: 'Event "Tech Career Fair" starts in 2 days!'),
                NotsTile(
                  icon: Icons.group,
                  message: 'You’ve been accepted into Women in STEM!',),
                NotsTile(
                  icon: Icons.calendar_today,
                  message: 'RSVP for "Mindfulness Meetup" ends tomorrow.',
                ),
              ],
            )
            ],

            ),
        ),
      );
  }
}
