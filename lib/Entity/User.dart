import 'LoginStatus.dart';

/*----------------------------------------------

ユーザーEntityクラス

----------------------------------------------*/
class User {
  String _id = ""; //ユーザーID
  String _name = ""; //ユーザー名前
  String _age = ""; //年齢
  String _sex = ""; //性別
  String _rank = "1"; //ユーザーランク
  String _mail = "";

  AuthProvider _provider;
  User();

  User.signUp(this._id, this._mail);

  User.signIn(this._id, this._mail, Map map)
      : _name = map["name"],
        _age = map["age"],
        _sex = map["sex"],
        _rank = map["rank"];

  toJson() {
    print("\n-----------send Data-----------\n"
        "userId:$_id\n"
        "name:$_name\n"
        "age:$_age\n"
        "sex:$_sex\n"
        "rank:$_rank\n"
        "mail:$_mail\n"
        "-------------------------------\n");
    return {
      "userId": _id,
      "name": _name,
      "age": _age,
      "sex": _sex,
      "rank": _rank,
      "mail": _mail,
    };
  }

  String get userId => _id;
  String get sex => _sex;
  String get name => _name;
  set setName(String value) => _name = value;
  set setSex(String value) => _sex = value;
  set setAge(String value) => _age = value;
  String get rank => _rank;
  set setRank(String value) {
    _rank = value;
  }
}
