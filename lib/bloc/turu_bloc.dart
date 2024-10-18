import 'dart:convert';
import '/helpers/api.dart';
import '/helpers/api_url.dart';
import '/model/turu.dart';

class PemantauanTidurBloc {
  static Future<List<PemantauanTidur>> getPemantauanTidurs() async {
    String apiUrl = ApiUrl.listPemantauanTidur; 
    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);
    List<dynamic> listPemantauanTidur = (jsonObj as Map<String, dynamic>)['data'];
    List<PemantauanTidur> pemantauanTidurs = [];
    for (int i = 0; i < listPemantauanTidur.length; i++) {
      pemantauanTidurs.add(PemantauanTidur.fromJson(listPemantauanTidur[i]));
    }
    return pemantauanTidurs;
  }

  static Future addPemantauanTidur({PemantauanTidur? pemantauanTidur}) async {
    String apiUrl = ApiUrl.createPemantauanTidur; 

    var body = {
      "sleep_quality": pemantauanTidur!.sleepQuality,
      "sleep_hours": pemantauanTidur.sleepHours.toString(),
      "sleep_disorders": pemantauanTidur.sleepDisorders
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future updatePemantauanTidur({required PemantauanTidur pemantauanTidur}) async {
    String apiUrl = ApiUrl.updatePemantauanTidur(pemantauanTidur.id!);

    var body = {
      "sleep_quality": pemantauanTidur.sleepQuality,
      "sleep_hours": pemantauanTidur.sleepHours.toString(),
      "sleep_disorders": pemantauanTidur.sleepDisorders
    };

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);
    return jsonObj['status'];
  }

  static Future<bool> deletePemantauanTidur({int? id}) async {
    String apiUrl = ApiUrl.deletePemantauanTidur(id!); 

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);
    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
