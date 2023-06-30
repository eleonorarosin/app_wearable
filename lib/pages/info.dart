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
                      'We have developed a sustainability app that tracks users steps, motivates them through messages, calculates the CO2 emissions saved (we have incorporated a formula based on existing literature that allows us to convert the distance traveled by car into kilograms of CO2 emitted by the vehicle), and promotes environmental consciousness. Our goal is to encourage users to reach a minimum of 10,000 steps per day, as it contributes to sustainable development. Walking 10,000 steps per day is a recommended practice by experts for maintaining a healthy lifestyle, but it also has a significant impact on sustainable development. By reducing car usage and opting for walking or public transportation, we can decrease carbon emissions and improve air quality in our communities. Additionally, walking promotes an active lifestyle and contributes to individuals physical and mental well-being.'),
                ]),
          )),
        ));
  } //build
} //Page