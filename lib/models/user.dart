class User {
  int? tblSysNoID;
  String? userLoginID;
  String? userPassword;
  int? userLoginStatus;

  User(
      {this.tblSysNoID,
      this.userLoginID,
      this.userPassword,
      this.userLoginStatus});

  User.fromJson(Map<String, dynamic> json) {
    tblSysNoID = json['TblSysNoID'];
    userLoginID = json['UserLoginID'];
    userPassword = json['UserPassword'];
    userLoginStatus = json['UserLoginStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TblSysNoID'] = tblSysNoID;
    data['UserLoginID'] = userLoginID;
    data['UserPassword'] = userPassword;
    data['UserLoginStatus'] = userLoginStatus;
    return data;
  }
}
