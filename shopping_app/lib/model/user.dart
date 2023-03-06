class myUser {
  String name;
  String email;
  String uid;

  myUser({required this.name, required this.email, required this.uid});
  //App to firebase(Map)
  Map<String, dynamic> toJson() => {"name": name, "email": email, "uid": uid};
  //firebase(map format) to App(user format)
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }
}
