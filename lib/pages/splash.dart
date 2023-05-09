import 'package:flutter/material.dart';

import 'home.dart';

class Splash extends StatelessWidget {
  static const route = '/splash/';
  static const routeDisplayName = 'SplashPage';

  const Splash({Key? key}) : super(key: key);

  // Method for navigation SplashPage -> HomePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
  } //_toHomePage

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => _toHomePage(context));
    return Material(
      child: Container(
        color: Color.fromARGB(255, 213, 243, 230),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'GreenSteps',
              style: TextStyle(
                  color: Color.fromARGB(255, 20, 134, 37),
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Icon(Icons.energy_savings_leaf),
                CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF89453C)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
