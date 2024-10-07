class User {
  String? username;
  int? age;
  String? gender;
  int? loginId;

  User({this.username, this.age, this.gender,this.loginId});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'age': age,
      'gender': gender,
      'loginId': loginId,
    };
  }

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    age = json['age'];
    gender = json['gender'];
    loginId = json['loginId'];
  }
}
