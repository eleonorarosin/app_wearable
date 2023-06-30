import 'package:app_wearable/models/entities/entities.dart';
import 'package:app_wearable/widgets/score_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:app_wearable/models/db.dart' as db;
import 'package:app_wearable/providers/home_provider.dart';
import 'package:provider/provider.dart';

/*List<Map<String, dynamic>> data = [
  {'date': '2023-05-23', 'points': 1468},
  {'date': '2023-05-23', 'points': 1487},
  {'date': '2023-05-23', 'points': 1494},
  {'date': '2023-05-22', 'points': 1526},
  {'date': '2023-05-22', 'points': 1492},
  {'date': '2023-05-22', 'points': 1470},
  {'date': '2023-05-22', 'points': 1477},
  {'date': '2023-05-21', 'points': 1466},
  {'date': '2023-05-21', 'points': 1465},
  {'date': '2023-05-21', 'points': 1524},
  {'date': '2023-05-21', 'points': 1534},
  {'date': '2023-05-20', 'points': 1504},
  {'date': '2023-05-20', 'points': 1524},
  {'date': '2023-05-19', 'points': 1534},
  {'date': '2023-05-19', 'points': 1463},
  {'date': '2021-10-07', 'points': 1502},
  {'date': '2021-10-07', 'points': 1539},
  {'date': '2021-10-08', 'points': 1476},
  {'date': '2021-10-08', 'points': 1483},
  {'date': '2021-10-08', 'points': 1534},
  {'date': '2021-10-08', 'points': 1530},
  {'date': '2021-10-09', 'points': 1519},
  {'date': '2021-10-09', 'points': 1497},
  {'date': '2021-10-09', 'points': 1460},
  {'date': '2021-10-10', 'points': 1514},
  {'date': '2021-10-10', 'points': 1518},
  {'date': '2021-10-10', 'points': 1470},
  {'date': '2021-10-10', 'points': 1526},
  {'date': '2021-10-11', 'points': 1517},
  {'date': '2021-10-11', 'points': 1478},
  {'date': '2021-10-11', 'points': 1468},
  {'date': '2021-10-11', 'points': 1487},
  {'date': '2021-10-12', 'points': 1535},
  {'date': '2021-10-12', 'points': 1537},
  {'date': '2021-10-12', 'points': 1463},
  {'date': '2021-10-12', 'points': 1478},
  {'date': '2021-10-13', 'points': 1524},
  {'date': '2021-10-13', 'points': 1496},
  {'date': '2021-10-14', 'points': 1527},
  {'date': '2021-10-14', 'points': 1527},
];*/

class Walk extends StatelessWidget {
  static const route = '/Walk/';
  static const routeDisplayName = 'WalkPage';

  Walk({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<HomeProvider>(
        builder: (context, provider, child) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Daily Activity',
              style: TextStyle(
                color: Color.fromARGB(255, 8, 112, 24),
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Steps Trend',
              style: TextStyle(
                color: Color.fromARGB(255, 8, 112, 24),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 150,
                height: 150,
                child: CustomPaint(
                  painter: ScoreCircularProgress(
                    backColor: const Color(0xFF89453C).withOpacity(0.4),
                    frontColor: const Color(0xFF89453C),
                    strokeWidth: 20,
                    value: provider.fullsteps /
                        10000, // Adjust the value range based on your desired maximum steps
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          '${provider.fullsteps}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Color.fromARGB(255, 8, 112, 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /*Text(
                    '${provider.fullsteps}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color.fromARGB(255, 8, 112, 24),
                    ),
                  ),*/
                  if (provider.fullsteps < 10000)
                    Text(
                      'Take a step towards a healthier you. Lace up those shoes and let each stride bring you closer to your goals.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(6, 6, 6, 0.925),
                      ),
                    ),
                  if (provider.fullsteps >= 10000)
                    Text(
                      'Congratulations on reaching your step goal! You have made great strides towards success and demonstrated your commitment to a healthy and sustainable lifestyle',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(6, 6, 6, 0.925),
                      ),
                    ),
                ],
              ),
            ),
            const Text(
              'Daily Trend',
              style: TextStyle(
                color: Color.fromARGB(255, 8, 112, 24),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
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
                  },
                ),
                Consumer<HomeProvider>(
                  builder: (context, value, child) => Text(
                    DateFormat('dd').format(value.showDate),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.navigate_next),
                  onPressed: () {
                    final provider =
                        Provider.of<HomeProvider>(context, listen: false);
                    DateTime day = provider.showDate;
                    provider.getDataOfDay(day.add(const Duration(days: 1)));
                  },
                ),
              ],
            ),
            Consumer<HomeProvider>(
              builder: (context, value, child) => SizedBox(
                height: 200,
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<FootSteps, DateTime>(
                      dataSource: provider.step,
                      xValueMapper: (FootSteps data, _) => data.dateTime,
                      yValueMapper: (FootSteps data, _) => data.value,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
             
              /*Consumer<HomeProvider>(
                builder: (context, value, child) =>
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: NumericAxis(),
                      series: <ChartSeries>[
                        ColumnSeries<Map<String, dynamic>, String>(
                          dataSource: data
                              .where(
                                (element) =>
                                    DateTime.parse(element['date']).isAfter(
                                        day.subtract(const Duration(days: 7))) &&
                                    DateTime.parse(element['date']).isBefore(day),
                              )
                              .toList(),
                          xValueMapper: (Map<String, dynamic> data, _) =>
                              data['date'].toString(),
                          yValueMapper: (Map<String, dynamic> data, _) =>
                              data['points'],
                        ),
                      ],
                    ),
                  ),
                )  
            ],
          ),
        ));
  }
  /*List<Map<String, dynamic>> _parseData(List<db.Exposure> data) {  //formato corretto dei dati
    return data
        .map(
          (e) => {
            'date': DateFormat('HH:mm').format(e.timestamp),
            'points': e.value
          },
        )
        .toList();*/*/

