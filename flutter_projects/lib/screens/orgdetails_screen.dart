import 'package:flutter/material.dart';
import 'package:flutter_projects/theme/theme.dart';

class OrgdetailsScreen extends StatelessWidget {
  final String name;
  final String logo;
  final String description;
  final String category;

  const OrgdetailsScreen({
    super.key,
  required this.name,
  required this.logo,
  required this.description,
  required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [

                Container(
                  height: screenHeight * 0.35,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image:
                    AssetImage('asset/image/logou.png'),
                    fit: BoxFit.cover,
                    ),
                  ),
                ),

                Positioned(
                  bottom: -50,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 46,
                          backgroundImage: AssetImage(logo),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('@$name'.toLowerCase().replaceAll(' ', '_'),
                          style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60,),

            Padding(
                padding:const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [ Text(description, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 40),
                    Chip(label: Text(category)),
                    const SizedBox( height: 20,),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Interest submitted!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightColorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          child: const Text('Join Organization', style: TextStyle(fontSize: 16)),
                    ),
                    ),
                  ],
                ),)
          ],
        ),
      ),
    );
  }
}
