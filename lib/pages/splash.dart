import 'package:flutter/material.dart';
import 'dart:math';
import 'home.dart';

class Splash extends StatefulWidget {
  static const route = '/splash/';
  static const routeDisplayName = 'SplashPage';

  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final List<String> _sustainabilityMessages = [
    "Education for sustainable development is crucial for creating a more sustainable future.",
    "Sustainable lifestyles are essential for preserving our planet for future generations.",
    "Human rights are an integral part of sustainable development.",
    "Gender equality is necessary for achieving sustainable development goals.",
    "Promoting a culture of peace and non-violence is fundamental to sustainable development.",
    "Global citizenship means taking responsibility for our impact on the planet and its people.",
    "Appreciating cultural diversity is essential for creating a more inclusive and sustainable world.",
    "Every small action counts towards sustainable development.",
    "We need to protect and preserve our natural resources for sustainable development.",
    "Sustainable development is not a choice, it's a necessity for our survival.",
    "A sustainable lifestyle is not only good for the environment but also for our health and wellbeing."
        "Sustainable development is about respecting the limits of our planet and its resources.",
    "Sustainability is the key to a better future for all.",
    "Sustainable choices lead to a healthier planet.",
    "We can all make a difference by choosing sustainable options.",
    "Sustainability is about meeting our needs without compromising the needs of future generations."
        "Sustainability is the path to a brighter and more sustainable future."
        "Sustainable living can save money and resources in the long run.",
    "Sustainability is about creating a world that works for everyone.",
    "Sustainable solutions are the only way forward for a better future."
  ];

  String? _randomMessage;

  @override
  void initState() {
    super.initState();
    _randomMessage = _sustainabilityMessages[
        Random().nextInt(_sustainabilityMessages.length)];
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 7),
        () => Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Home())));

    return Material(
      child: Container(
        color: Color.fromARGB(255, 228, 223, 212),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.energy_savings_leaf, size: 48),
                SizedBox(height: 16),
                Text(
                  _randomMessage!,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF89453C)),
            ),
          ],
        ),
      ),
    );
  }
}
