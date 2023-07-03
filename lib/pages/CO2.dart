import 'package:flutter/material.dart';
import 'package:app_wearable/models/entities/entities.dart' as db;
import 'package:app_wearable/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CO2 extends StatelessWidget {
  static const route = '/co2/';
  static const routeDisplayName = 'CO2Page';

  const CO2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final _formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Your help to the environment',
              style: TextStyle(
                  color: Color.fromARGB(255, 20, 134, 37),
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Car type',
              style: TextStyle(
                  color: Color.fromARGB(255, 20, 134, 37),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 150,
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    RadioListTile<int>(
                      title: const Text('Gas or Diesel'),
                      value: 0,
                      groupValue: provider.selectedCarType,
                      onChanged: (val) {
                        provider.setSelectedCarType(val!);
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('Electric'),
                      value: 1,
                      groupValue: provider.selectedCarType,
                      onChanged: (val) {
                        provider.setSelectedCarType(val!);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'CO2 saved today',
              style: TextStyle(
                  color: Color.fromARGB(255, 20, 134, 37),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            Consumer<HomeProvider>(
              builder: (context, value, child) {
                double co2Saved = 0.0;
                if (provider.selectedCarType == 0) {
                  co2Saved = 0.1879 * provider.fulldistances/100000;
                } else if (provider.selectedCarType == 1) {
                  co2Saved = 0.0525 * provider.fulldistances/100000;
                }
                return Center(
                  child: Column(
                    children: [
                      Text(
                        '${co2Saved.toStringAsFixed(2)} kg',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "Today, your eco-conscious choices made a difference! By walking and engaging in exercise sessions, you helped reduce CO2 emissions and contributed to a greener planet.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
