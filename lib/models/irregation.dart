class Irregation {
  String? uid;
  bool isActive;
  int isTemperature;
  int isHeater;
  double temperature;
  Valve valve1;
  Valve valve2;

  Irregation({
    this.uid,
    required this.isActive,
    required this.isTemperature,
    required this.temperature,
    required this.valve1,
    required this.valve2,
    required this.isHeater,
  });

  factory Irregation.fromJson(Map<dynamic, dynamic> json) => Irregation(
        uid: json["uid"],
        isActive: json["isActive"],
        isTemperature: json["isTemperature"].toInt(),
        isHeater: json["isHeater"].toInt(),
        temperature: json["temperature"].toDouble(),
        valve1: Valve.fromJson(json["valve1"] as Map<dynamic, dynamic>),
        valve2: Valve.fromJson(json["valve2"] as Map<dynamic, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isActive": isActive,
        "isTemperature": isTemperature,
        "temperature": temperature,
        "isHeater": isHeater,
        "valve1": valve1.toJson(),
        "valve2": valve2.toJson(),
      };
}

class Valve {
  String title;
  String type;
  bool state;
  int time;
  int turnOnEvery;
  List<int> times;
  List<int> days;

  Valve({
    required this.title,
    required this.type,
    required this.state,
    required this.time,
    required this.turnOnEvery,
    required this.times,
    required this.days,
  });

  factory Valve.fromJson(Map<dynamic, dynamic> json) => Valve(
        title: json["title"],
        type: json["type"],
        state: json["state"],
        time: json["time"],
        turnOnEvery: json["turnOnEvery"],
        times: List<int>.from(json["times"].map((x) => x)),
        days: List<int>.from(json["days"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "type": type,
        "state": state,
        "time": time,
        "turnOnEvery": turnOnEvery,
        "times": List<dynamic>.from(times.map((x) => x)),
        "days": List<dynamic>.from(days.map((x) => x)),
      };
}
