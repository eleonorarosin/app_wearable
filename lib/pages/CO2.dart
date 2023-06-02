import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:app_wearable/models/db.dart' as db;
import 'package:app_wearable/providers/home_provider.dart';
import 'package:provider/provider.dart';

class CO2 extends StatelessWidget {
  static const route = '/CO2/';
  static const routeDisplayName = 'CO2Page';

  CO2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(8.0));
  }

}