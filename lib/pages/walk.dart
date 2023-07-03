import 'package:app_wearable/models/entities/entities.dart';
import 'package:app_wearable/widgets/score_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:app_wearable/models/db.dart' as db;
import 'package:app_wearable/providers/home_provider.dart';
import 'package:provider/provider.dart';

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
            const Text(
      'Your goal is 10000 steps',
      style: TextStyle(
        color: Color.fromARGB(255, 8, 112, 24),
        fontSize: 16,
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
                    const Text(
                      'Take a step towards a healthier you. Lace up those shoes and let each stride bring you closer to your goals.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromRGBO(6, 6, 6, 0.925),
                      ),
                    ),
                  if (provider.fullsteps >= 10000)
                    const Text(
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
                    DateFormat('MMM-dd').format(value.showDate),
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
                  primaryXAxis: CategoryAxis(
                  ),
                  primaryYAxis: NumericAxis(),
                    series: <ChartSeries>[
                      ColumnSeries<FootSteps, String>(
                        dataSource: provider.steps3h,
                        xValueMapper: (FootSteps data, _) => DateFormat('HH').format(data.dateTime),
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
