import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:app_wearable/utils/shared_preferences.dart';
import 'package:app_wearable/models/db.dart';

class ImpactService {
  ImpactService(this.prefs) {
    updateBearer();
  }
  Preferences prefs;

  final Dio _dio = Dio(BaseOptions(baseUrl: ServerStrings.backendBaseUrl));//usare http e funziona uguale

  String? retrieveSavedToken(bool refresh) {
    if (refresh) {
      return prefs.impactRefreshToken;
    } else {
      return prefs.impactAccessToken;
    }
  }

  bool checkSavedToken({bool refresh = false}) {
    String? token = retrieveSavedToken(refresh);
    //Check if there is a token
    if (token == null) {
      return false;
    }
    try {
      return ImpactService.checkToken(token);
    } catch (_) {
      return false;
    }
  }

  // this method is static because we might want to check the token outside the class itself
  static bool checkToken(String token) { //ci interessa
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) { //spacchetta e lo fa divntare una mappa
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    //Check the iss claim
    if (decodedToken['iss'] == null) { //fino a 49 nin serve
      return false;
    } else {
      if (decodedToken['iss'] != ServerStrings.issClaim) {
        return false;
      } //else
    } //if-else

    //Check that the user is a patient
    if (decodedToken['role'] == null) {  //da fare 
      return false;
    } else {
      if (decodedToken['role'] != ServerStrings.researcherRoleIdentifier) {
        return false;
      } //else
    } //if-else

    return true;
  } //checkToken

  // make the call to get the tokens
  Future<bool> getTokens(String username, String password) async {
    try {
      Response response = await _dio.post(
          '${ServerStrings.authServerUrl}token/',
          data: {'username': username, 'password': password},
          options: Options( //delle volte non servono le options
              contentType: 'application/json',
              followRedirects: false,
              validateStatus: (status) => true,
              headers: {"Accept": "application/json"}));

      if (ImpactService.checkToken(response.data['access']) &&
          ImpactService.checkToken(response.data['refresh'])) {
        prefs.impactRefreshToken = response.data['refresh'];
        prefs.impactAccessToken = response.data['access'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }
  Future<bool> refreshTokens() async {
    String? refToken = await retrieveSavedToken(true);
    try {
      Response response = await _dio.post(
          '${ServerStrings.authServerUrl}refresh/',
          data: {'refresh': refToken},
          options: Options(
              contentType: 'application/json',
              followRedirects: false,
              validateStatus: (status) => true,
              headers: {"Accept": "application/json"}));

      if (ImpactService.checkToken(response.data['access']) &&
          ImpactService.checkToken(response.data['refresh'])) {
        prefs.impactRefreshToken = response.data['refresh'];
        prefs.impactAccessToken = response.data['access'];
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateBearer() async {
    if (!await checkSavedToken()) {
      await refreshTokens();
    }
    String? token = await prefs.impactAccessToken;
    if (token != null) {
      _dio.options.headers = {'Authorization': 'Bearer $token'};
    }
  }

  Future<void> getPatient() async {
    await updateBearer();
    Response r = await _dio.get('study/v1/patients/active');
    prefs.impactUsername = r.data['data'][0]['username'];
    return r.data['data'][0]['username'];
  }

  Future<List<Distance>> getDataFromDay(DateTime startTime) async {
    await updateBearer();
    Response r = await _dio.get(
        'data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/');
    List<dynamic> data = r.data['data'];
    List<Distance> dist = [];
    for (var daydata in data) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        Distance distnew = Distance(timestamp: timestamp, value: dataday['value']);
        if (!dist.any((e) => e.timestamp.isAtSameMomentAs(distnew.timestamp))) {
          dist.add(distnew);
        }
      }
    }
    var distlist = dist.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return distlist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}



/*import 'dart:convert';

import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:app_wearable/services/server_strings.dart';
import 'package:app_wearable/utils/shared_preferences.dart';
import 'package:app_wearable/models/db.dart';

class ImpactService {
  ImpactService(this.prefs) {
    updateBearer();
  }

  Preferences prefs;
  final http.Client _client = http.Client();

  String? retrieveSavedToken(bool refresh) {
    if (refresh) {
      return prefs.impactRefreshToken;
    } else {
      return prefs.impactAccessToken;
    }
  }

  bool checkSavedToken({bool refresh = false}) {
    String? token = retrieveSavedToken(refresh);
    //Check if there is a token
    if (token == null) {
      return false;
    }
    try {
      return ImpactService.checkToken(token);
    } catch (_) {
      return false;
    }
  }

  static bool checkToken(String token) {
    if (JwtDecoder.isExpired(token)) {
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    if (decodedToken['iss'] == null) {
      return false;
    } else {
      if (decodedToken['iss'] != ServerStrings.issClaim) {
        return false;
      }
    }

    if (decodedToken['role'] == null) {
      return false;
    } else {
      if (decodedToken['role'] != ServerStrings.researcherRoleIdentifier) {
        return false;
      }
    }

    return true;
  }

  Future<bool> getTokens(String username, String password) async {
    try {
      final response = await _client.post(
        Uri.parse('${ServerStrings.authServerUrl}token/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (ImpactService.checkToken(data['access']) &&
            ImpactService.checkToken(data['refresh'])) {
          prefs.impactRefreshToken = data['refresh'];
          prefs.impactAccessToken = data['access'];
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> refreshTokens() async {
    String? refToken = await retrieveSavedToken(true);
    try {
      final response = await _client.post(
        Uri.parse('${ServerStrings.authServerUrl}refresh/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh': refToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (ImpactService.checkToken(data['access']) &&
            ImpactService.checkToken(data['refresh'])) {
          prefs.impactRefreshToken = data['refresh'];
          prefs.impactAccessToken = data['access'];
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateBearer() async {
    if (!await checkSavedToken()) {
      await refreshTokens();
    }
    String? token = await prefs.impactAccessToken;
    if (token != null) {
      _client.head(Uri.parse('http://example.com'),
          headers: {'Authorization': 'Bearer $token'});
    }
  }

  Future<void> getPatient() async {
    await updateBearer();
    final response = await _client.get(
      Uri.parse('${ServerStrings.backendBaseUrl}study/v1/patients/active'),
    );
    final data = jsonDecode(response.body);
    prefs.impactUsername = data['data'][0]['username'];
  }

  Future<List<Distance>> getDataFromDay(DateTime startTime) async {
    await updateBearer();
    final response = await _client.get(
      Uri.parse(
        '${ServerStrings.backendBaseUrl}data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/',
      ),
    );
    final data = jsonDecode(response.body);
    List<Distance> dist = [];
    for (var daydata in data['data']) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        Distance distnew =
            Distance(timestamp: timestamp, value: dataday['value']);
        if (!dist.any((e) => e.timestamp.isAtSameMomentAs(distnew.timestamp))) {
          dist.add(distnew);
        }
      }
    }
    var distlist = dist.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return distlist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
      input.year,
      input.month,
      input.day,
      input.hour,
      input.minute,
    );
  }
}*/
