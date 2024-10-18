class PemantauanTidur {
  int? id;
  String? sleepQuality;
  int? sleepHours;
  String? sleepDisorders;

  // Constructor
  PemantauanTidur(
      {this.id, this.sleepQuality, this.sleepHours, this.sleepDisorders});

  // Factory method to create an instance of PemantauanTidur from a JSON map
  factory PemantauanTidur.fromJson(Map<String, dynamic> json) {
    return PemantauanTidur(
      id: json['id'],
      sleepQuality: json['sleep_quality'],
      sleepHours: json['sleep_hours'],
      sleepDisorders: json['sleep_disorders'],
    );
  }

  // Method to convert the model to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sleep_quality': sleepQuality,
      'sleep_hours': sleepHours,
      'sleep_disorders': sleepDisorders,
    };
  }
}
