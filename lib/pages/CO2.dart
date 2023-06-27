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
    final _formKey = GlobalKey<FormState>();

    double? radioValue;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      // here we use a consumer to react to the changes in the provider, which are triggered by the notifyListener method
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
                child: Column(children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(width: 10),
                      const Text('Car',
                          style: TextStyle(
                              color: Color.fromARGB(255, 20, 134, 37),
                              fontSize: 17)),
                      Radio(
                        fillColor: MaterialStateColor.resolveWith(
                            (states) => const Color.fromARGB(255, 20, 134, 37)),
                        value: 0.1879,
                        groupValue: radioValue,
                        onChanged: (val) {
                          radioValue = val;
                        },
                      ),
                      const Text(
                        'Diesel',
                        style: TextStyle(fontSize: 17.0),
                      ),
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color.fromARGB(255, 20, 134, 37)),
                          value: 0.1879,
                          groupValue: radioValue,
                          onChanged: (val) {
                            radioValue = val;
                          }),
                      const Text(
                        'Gas',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      Radio(
                          fillColor: MaterialStateColor.resolveWith(
                              (states) => Color.fromARGB(255, 20, 134, 37)),
                          value: 0.0525,
                          groupValue: radioValue,
                          onChanged: (val) {
                            radioValue = val;
                          }),
                      const Text(
                        'Electric',
                        style: TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                    ],
                  ),
                ]),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    icon: const Icon(Icons.navigate_before),
                    onPressed: () {
                      // here we use the access method to retrieve the Provider and use its values and methods
                      final provider =
                          Provider.of<HomeProvider>(context, listen: false);
                      DateTime day = provider.showDate;
                      provider
                          .getDataOfDay(day.subtract(const Duration(days: 1)));
                    }),
                Consumer<HomeProvider>(
                    builder: (context, value, child) => Text(
                        DateFormat('dd MMMM yyyy').format(value.showDate))),
                IconButton(
                    icon: const Icon(Icons.navigate_next),
                    onPressed: () {
                      final provider =
                          Provider.of<HomeProvider>(context, listen: false);
                      DateTime day = provider.showDate;
                      provider.getDataOfDay(day.add(const Duration(days: 1)));
                    })
              ],
            ),
            Consumer<HomeProvider>(
                builder: (context, value, child) =>
                    calculateCO2(value, provider.fulldistances))
          ],
        ),
      ),
    );
  }

  Text calculateCO2(value, distances) {
    return Text('${(value * distances)} kg of CO2 saved today',
        style: TextStyle(fontSize: 16));
  }
}
