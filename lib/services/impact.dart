/*import 'package:app_wearable/models/entities/entities.dart';
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

  final Dio _dio = Dio(BaseOptions(
      baseUrl: ServerStrings.backendBaseUrl)); //usare http e funziona uguale

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
  static bool checkToken(String token) {
    //ci interessa
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) {
      //spacchetta e lo fa divntare una mappa
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    //Check the iss claim
    if (decodedToken['iss'] == null) {
      //fino a 49 nin serve
      return false;
    } else {
      if (decodedToken['iss'] != ServerStrings.issClaim) {
        return false;
      } //else
    } //if-else

    //Check that the user is a patient
    if (decodedToken['role'] == null) {
      //da fare
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
      print('${ServerStrings.authServerUrl}token/');
      Response response =
          await _dio.post('${ServerStrings.authServerUrl}token/',
              data: {'username': username, 'password': password},
              options: Options(
                  //delle volte non servono le options
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

  Future<List<FootDistances>> getDistancesFromDay(DateTime startTime) async {
    await updateBearer();
    Response r = await _dio.get(
        'data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/');
    List<dynamic> data = r.data['data'];
    List<FootDistances> dist = [];
    for (var daydata in data) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootDistances distnew =
            FootDistances(null, int.parse(dataday['value']), timestamp);
        if (!dist.any((e) => e.dateTime.isAtSameMomentAs(distnew.dateTime))) {
          dist.add(distnew);
        }
      }
    }
    var distlist = dist.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return distlist;
  }

  Future<List<FootSteps>> getStepsFromDay(DateTime startTime) async {
    await updateBearer();
    Response r = await _dio.get(
        'data/v1/steps/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/');
    List<dynamic> data = r.data['data'];
    List<FootSteps> step = [];
    for (var daydata in data) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootSteps stepnew =
            FootSteps(null, int.parse(dataday['value']), timestamp);
        if (!step.any((e) => e.dateTime.isAtSameMomentAs(stepnew.dateTime))) {
          step.add(stepnew);
        }
      }
    }
    var steplist = step.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return steplist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}*/
/*
import 'dart:convert';

import 'package:app_wearable/models/entities/entities.dart';
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

  Future<List<FootDistances>> getDataFromDay(DateTime startTime) async {
    await updateBearer();
    final response = await _client.get(
      Uri.parse(
        '${ServerStrings.backendBaseUrl}data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/',
      ),
    );
    final data = jsonDecode(response.body);
    List<FootDistances> dist = [];
    for (var daydata in data['data']) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootDistances distnew =
            FootDistances(timestamp: timestamp, value: dataday['value']);
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
}
import 'dart:convert';
import 'dart:io';
import 'package:app_wearable/models/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_wearable/utils/shared_preferences.dart';

import '../models/db.dart';

class ImpactService {
  ImpactService(this.prefs);
  Preferences prefs;
//   //serve per poterle poi utilizzare, servizio per fare chiamate unico e non rischio di avere più sezioni aperte

//   //final Dio _dio = Dio(BaseOptions(baseUrl: ServerStrings.backendBaseUrl));

  getRequest() async {
    try {
      final response = await http.get(Uri.parse(ServerStrings.backendBaseUrl));
      if (response.statusCode == 200) {
        //la richiesta è andata a buon fine
        print(response.body);
        return true;
      } else {
        //la richiesta non ha restituito un codice diverso
        print('Errore nella richiesta: $response.statusCode');
        return false;
      }
    } catch (e) {
      // si è verificato un'errore ritorna l'errore
      print('errore durante la richiesta:$e');
      return false;
    }
  }

  String? retrieveSavedToken(bool refresh) {
    //mi rcorda preferences necessarie
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
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) {
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return true;
  } //checkToken

  Future<bool> getTokens(String username, String password) async {
    final url =
        ServerStrings.backendBaseUrl + ServerStrings.authServerUrl + '/token/';
    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url),
        body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
      return true;
    } else {
      //if

      //Just return the status code
      return false;
    }
  }

  Future<void> getPatient() async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl + 'study/v1/patients/active/'),
        headers: headers);
    Map<String, dynamic> body = json.decode(r.body);
    prefs.impactUsername = body['data'][0]['username'];
    return body['data'][0]['username'];
    //vado a vedere se un paziente, aggiorno prima paziente per fare chiamata da utorizzati poi faccio una get e poi dalla risposta prendo il primo utente, lo salvo in preferences
    //restituisco username
  }

  Future<List<FootDistances>> getDistancesFromDay(DateTime startTime) async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    // dynamic r = await http.get(Uri.parse(ServerStrings.backendBaseUrl+'/data/v1/distance/patients/${prefs.impactUsername}/day/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),headers: headers);
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl +
            '/data/v1/distances/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: headers);
    Map<String, dynamic> body = json.decode(r.body);
    //List<dynamic> data = body['data']['date'];
    List<dynamic> data = body['data'];
    //List<Distance> distance = body['data'][1]['data'];
    List<FootDistances> distance = [];
    for (var daydata in data) {
      String day = daydata['date']; //prendo stringa prento il time e ricompatto
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootDistances distancenew =
            FootDistances(null, int.parse(dataday['value']), timestamp);
        if (!distance
            .any((e) => e.dateTime.isAtSameMomentAs(distancenew.dateTime))) {
          distance.add(distancenew);
        }
      }
    }
    var distancelist = distance.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return distancelist;
  }

  Future<List<FootSteps>> getStepsFromDay(DateTime startTime) async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    //dynamic r = await http.get(Uri.parse(ServerStrings.backendBaseUrl+'/data/v1/steps/patients/${prefs.impactUsername}/day/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),headers: headers);
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl +
            '/data/v1/steps/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: headers);
    Map<String, dynamic> body = json.decode(r.body);
    List<dynamic> data = body['data'];
    //List<FootStep> footstep = body['data'][1]['data'];
    List<FootSteps> footstep = [];
    for (var daydata in data) {
      String day = daydata['date']; //prendo stringa prento il time e ricompatto
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootSteps footstepnew =
            FootSteps(null, int.parse(dataday['value']), timestamp);
        if (!footstep
            .any((e) => e.dateTime.isAtSameMomentAs(footstepnew.dateTime))) {
          footstep.add(footstepnew);
        }
      }
    }
    var footsteplist = footstep.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return footsteplist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}*/

/*import 'package:app_wearable/models/entities/entities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:app_wearable/utils/shared_preferences.dart';
import 'package:app_wearable/models/db.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'dart:convert';

class ImpactService {
  ImpactService(this.prefs) {
    updateBearer();
  } //Impact

  static String baseUrl => 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String stepsEndpoint = 'data/v1/steps/patients/';

  static String username = '<YOUR_USERNAME>';
  static String password = '<YOUR_PASSWORD>';

  static String patientUsername = 'Jpefaq6m58';
//Impact
  Preferences prefs;

  final String baseUrl = ServerStrings.backendBaseUrl;

  String? retrieveSavedToken(bool refresh) {
    if (refresh) {
      return prefs.impactRefreshToken;
    } else {
      return prefs.impactAccessToken;
    }
  }

  bool checkSavedToken({bool refresh = false}) {
    String? token = retrieveSavedToken(refresh);
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
      final response = await http.post(
        Uri.parse('${ServerStrings.authServerUrl}token/'),
        body: jsonEncode({'username': username, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (ImpactService.checkToken(responseData['access']) &&
            ImpactService.checkToken(responseData['refresh'])) {
          prefs.impactRefreshToken = responseData['refresh'];
          prefs.impactAccessToken = responseData['access'];
          return true;
        } else {
          return false;
        }
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
      final response = await http.post(
        Uri.parse('${ServerStrings.authServerUrl}refresh/'),
        body: jsonEncode({'refresh': refToken}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (ImpactService.checkToken(responseData['access']) &&
            ImpactService.checkToken(responseData['refresh'])) {
          prefs.impactRefreshToken = responseData['refresh'];
          prefs.impactAccessToken = responseData['access'];
          return true;
        } else {
          return false;
        }
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
  }

  Future<void> getPatient() async {
    await updateBearer();
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/study/v1/patients/active'),
        headers: {'Authorization': 'Bearer ${prefs.impactAccessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        prefs.impactUsername = responseData['data'][0]['username'];
        return responseData['data'][0]['username'];
      } else {
        throw Exception('Failed to get patient');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to get patient');
    }
  }

  Future<List<FootDistances>> getDistancesFromDay(DateTime startTime) async {
    await updateBearer();
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/data/v1/distances/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: {'Authorization': 'Bearer ${prefs.impactAccessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        List<FootDistances> dist = [];
        for (var daydata in data) {
          String day = daydata['date'];
          for (var dataday in daydata['data']) {
            String hour = dataday['time'];
            String datetime = '${day}T$hour';
            DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
            FootDistances distnew =
                FootDistances(null, int.parse(dataday['value']), timestamp);
            if (!dist
                .any((e) => e.dateTime.isAtSameMomentAs(distnew.dateTime))) {
              dist.add(distnew);
            }
          }
        }
        var distlist = dist.toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
        return distlist;
      } else {
        throw Exception('Failed to get distances');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to get distances');
    }
  }

  Future<List<FootSteps>> getStepsFromDay(DateTime startTime) async {
    await updateBearer();
    try {
      final response = await http.get(
        Uri.parse(
            '$baseUrl/data/v1/steps/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: {'Authorization': 'Bearer ${prefs.impactAccessToken}'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        List<dynamic> data = responseData['data'];
        List<FootSteps> step = [];
        for (var daydata in data) {
          String day = daydata['date'];
          for (var dataday in daydata['data']) {
            String hour = dataday['time'];
            String datetime = '${day}T$hour';
            DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
            FootSteps stepnew =
                FootSteps(null, int.parse(dataday['value']), timestamp);
            if (!step
                .any((e) => e.dateTime.isAtSameMomentAs(stepnew.dateTime))) {
              step.add(stepnew);
            }
          }
        }
        var steplist = step.toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
        return steplist;
      } else {
        throw Exception('Failed to get steps');
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to get steps');
    }
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}*/
/*import 'dart:convert';
import 'dart:io';
import 'package:app_wearable/models/entities/entities.dart';
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
      _client.head(Uri.parse('https://impact.dei.unipd.it/bwthw/'),
          headers: {'Authorization': 'Bearer $token'});
    }
  }

  Future<void> getPatient() async {
    await updateBearer();
    dynamic response = await _client.get(
      Uri.parse('${ServerStrings.backendBaseUrl}study/v1/patients/active'),
    );
    Map<String, dynamic> data = jsonDecode(response.body);
    prefs.impactUsername = data['data'][0]['username'];
    return data['data'][0]['username'];
  }

  Future<List<FootDistances>> getDistancesFromDay(DateTime startTime) async {
    await updateBearer();
    final response = await _client.get(
      Uri.parse(
        '${ServerStrings.backendBaseUrl}data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/',
      ),
    );
    final data = jsonDecode(response.body);
    print(data);
    List<FootDistances> dist = [];
    for (var daydata in data['data']) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootDistances distnew =
            FootDistances(null, int.parse(dataday['value']), timestamp);
        if (!dist.any((e) => e.dateTime.isAtSameMomentAs(distnew.dateTime))) {
          dist.add(distnew);
        }
      }
    }
    var distlist = dist.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return distlist;
  }

  Future<List<FootSteps>> getStepsFromDay(DateTime startTime) async {
    await updateBearer();
    final response = await _client.get(
      Uri.parse(
        '${ServerStrings.backendBaseUrl}data/v1/steps/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/',
      ),
    );
    final data = jsonDecode(response.body);
    List<FootSteps> footstep = [];
    for (var daydata in data['data']) {
      String day = daydata['date'];
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootSteps footstepnew =
            FootSteps(null, int.parse(dataday['value']), timestamp);
        if (!footstep
            .any((e) => e.dateTime.isAtSameMomentAs(footstepnew.dateTime))) {
          footstep.add(footstepnew);
        }
      }
    }
    var steplist = footstep.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return steplist;
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
import 'dart:convert';
import 'dart:io';
import 'package:app_wearable/models/entities/entities.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter/material.dart';
import 'package:app_wearable/services/server_strings.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_wearable/utils/shared_preferences.dart';

import '../models/db.dart';

class ImpactService {
  ImpactService(this.prefs);
  Preferences prefs;
//   //serve per poterle poi utilizzare, servizio per fare chiamate unico e non rischio di avere più sezioni aperte

//   //final Dio _dio = Dio(BaseOptions(baseUrl: ServerStrings.backendBaseUrl));

  getRequest() async {
    try {
      final response = await http.get(Uri.parse(ServerStrings.backendBaseUrl));
      if (response.statusCode == 200) {
        //la richiesta è andata a buon fine
        print(response.body);
        return true;
      } else {
        //la richiesta non ha restituito un codice diverso
        print('Errore nella richiesta: $response.statusCode');
        return false;
      }
    } catch (e) {
      // si è verificato un'errore ritorna l'errore
      print('errore durante la richiesta:$e');
      return false;
    }
  }

  String? retrieveSavedToken(bool refresh) {
    //mi rcorda preferences necessarie
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
    //Check if the token is expired
    if (JwtDecoder.isExpired(token)) {
      return false;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    return true;
  } //checkToken

  Future<bool> getTokens(String username, String password) async {
    final url =
        ServerStrings.backendBaseUrl + ServerStrings.authServerUrl + '/token/';
    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url),
        body: {'username': username, 'password': password});
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
      return true;
    } else {
      //if

      //Just return the status code
      return false;
    }
  }

  Future<void> getPatient() async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl + 'study/v1/patients/active/'),
        headers: headers);
    Map<String, dynamic> body = json.decode(r.body);
    prefs.impactUsername = body['data'][0]['username'];
    return body['data'][0]['username'];
    //vado a vedere se un paziente, aggiorno prima paziente per fare chiamata da utorizzati poi faccio una get e poi dalla risposta prendo il primo utente, lo salvo in preferences
    //restituisco username
  }

  Future<List<FootDistances>> getDistancesFromDay(DateTime startTime) async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    // dynamic r = await http.get(Uri.parse(ServerStrings.backendBaseUrl+'/data/v1/distance/patients/${prefs.impactUsername}/day/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),headers: headers);
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl +
            'data/v1/distance/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: headers);
    print(r);

    Map<String, dynamic> body = json.decode(r.body);
    //List<dynamic> data = body['data']['date'];
    List<dynamic> data = body['data'];
    //List<Distance> distance = body['data'][1]['data'];
    List<FootDistances> distance = [];
    for (var daydata in data) {
      String day = daydata['date']; //prendo stringa prento il time e ricompatto
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootDistances distancenew =
            FootDistances(null, int.parse(dataday['value']), timestamp);
        if (!distance
            .any((e) => e.dateTime.isAtSameMomentAs(distancenew.dateTime))) {
          distance.add(distancenew);
        }
      }
    }
    var distancelist = distance.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return distancelist;
  }

  Future<List<FootSteps>> getStepsFromDay(DateTime startTime) async {
    final sp = await SharedPreferences.getInstance();
    String access = sp.getString('access')!;
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    //dynamic r = await http.get(Uri.parse(ServerStrings.backendBaseUrl+'/data/v1/steps/patients/${prefs.impactUsername}/day/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),headers: headers);
    dynamic r = await http.get(
        Uri.parse(ServerStrings.backendBaseUrl +
            '/data/v1/steps/patients/${prefs.impactUsername}/daterange/start_date/${DateFormat('y-M-d').format(startTime)}/end_date/${DateFormat('y-M-d').format(DateTime.now().subtract(const Duration(days: 1)))}/'),
        headers: headers);
    Map<String, dynamic> body = json.decode(r.body);
    List<dynamic> data = body['data'];
    //List<FootStep> footstep = body['data'][1]['data'];
    List<FootSteps> footstep = [];
    for (var daydata in data) {
      String day = daydata['date']; //prendo stringa prento il time e ricompatto
      for (var dataday in daydata['data']) {
        String hour = dataday['time'];
        String datetime = '${day}T$hour';
        DateTime timestamp = _truncateSeconds(DateTime.parse(datetime));
        FootSteps footstepnew =
            FootSteps(null, int.parse(dataday['value']), timestamp);
        if (!footstep
            .any((e) => e.dateTime.isAtSameMomentAs(footstepnew.dateTime))) {
          footstep.add(footstepnew);
        }
      }
    }
    var footsteplist = footstep.toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
    return footsteplist;
  }

  DateTime _truncateSeconds(DateTime input) {
    return DateTime(
        input.year, input.month, input.day, input.hour, input.minute);
  }
}
