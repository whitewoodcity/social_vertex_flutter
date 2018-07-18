class NewUser{
  String _userName;
  String _password;

  NewUser(this._userName,this._password);
  Map<String, dynamic> toJson() =>
      {
        'userName': _userName,
        'password': _password,
      };
}