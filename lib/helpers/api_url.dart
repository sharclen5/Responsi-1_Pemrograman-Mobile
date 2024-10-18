class ApiUrl {
  static const String baseUrl = 'http://responsi.webwizards.my.id/api/kesehatan';
  static const String listPemantauanTidur = baseUrl + '/pemantauan_tidur';
  static const String createPemantauanTidur = baseUrl + '/pemantauan_tidur';

  static const String registrasi = 'http://responsi.webwizards.my.id/api/registrasi';
  static const String login = 'http://responsi.webwizards.my.id/api/login';


  static String showPemantauanTidur(int id) {
    return baseUrl + '/pemantauan_tidur/' + id.toString();
  }

  static String updatePemantauanTidur(int id) {
    return baseUrl + '/pemantauan_tidur/' + id.toString() + '/update';
  }

  static String deletePemantauanTidur(int id) {
    return baseUrl + '/pemantauan_tidur/' + id.toString() + '/delete';
  }
}
