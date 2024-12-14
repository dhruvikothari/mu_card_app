class User {
  String userName;
  String userEmail;
  String phoneNum;

  User(this.userName, this.userEmail, this.phoneNum);

  Map<String, dynamic> toJson() => {
        'name': userName.toString(),
        'email': userEmail.toString(),
        'phoneNum': phoneNum.toString()
      };
}
