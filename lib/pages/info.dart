import 'package:flutter/material.dart';

class InfoApp extends StatelessWidget {
  const InfoApp({Key? key}) : super(key: key);

  static const route = '/infoapp/';
  static const routename = 'InfoApp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 228, 223, 212),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 228, 223, 212),
          iconTheme:
              const IconThemeData(color: Color.fromARGB(255, 8, 112, 24)),
          title: const Text('About', style: TextStyle(color: Colors.black)),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'App info',
                    style: TextStyle(
                        color: Color.fromARGB(255, 8, 112, 24),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                      'We have developed a sustainability app that tracks users steps, motivates them through messages, calculates their carbon footprint, and promotes environmental consciousness. It encourages walking or using public transportation instead of driving, providing incentives and educational content. By taking small steps towards sustainability, users can make a positive impact on the environment and combat climate change.'),
                ]),
          )),
        ));
  } //build
} //Page