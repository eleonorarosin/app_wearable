
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
