class Irregation {
  String? uid;
  bool isActive;
  bool isHour;
  double temperature;
  Valve valve1;
  Valve valve2;
  Valve valve3;
  Valve valve4;

  Irregation({
    this.uid,
    required this.isActive,
    required this.isHour,
    required this.temperature,
    required this.valve1,
    required this.valve2,
    required this.valve3,
    required this.valve4,
  });

  factory Irregation.fromJson(Map<dynamic, dynamic> json) => Irregation(
        uid: json["uid"],
        isActive: json["isActive"],
        isHour: json["isHour"],
        temperature: json["temperature"].toDouble(),
        valve1: Valve.fromJson(json["valve1"] as Map<dynamic, dynamic>),
        valve2: Valve.fromJson(json["valve2"] as Map<dynamic, dynamic>),
        valve3: Valve.fromJson(json["valve3"] as Map<dynamic, dynamic>),
        valve4: Valve.fromJson(json["valve4"] as Map<dynamic, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "isActive": isActive,
        "isHour": isHour,
        "temperature": temperature,
        "valve1": valve1.toJson(),
        "valve2": valve2.toJson(),
        "valve3": valve3.toJson(),
        "valve4": valve4.toJson(),
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
