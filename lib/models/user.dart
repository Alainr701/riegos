class User {
  String? uid;
  String name;
  String email;
  bool state;
  int phone;
  int age;
  String type;
  User({
    this.uid,
    required this.name,
    required this.email,
    required this.state,
    required this.phone,
    required this.age,
    required this.type,
  });
  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['gmail'],
      state: json['state'],
      phone: json['phone'].toInt(),
      age: json['age'].toInt(),
      type: json['type'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'gmail': email,
      'state': state,
      'phone': phone,
      'age': age,
      'type': type,
    };
  }
}
