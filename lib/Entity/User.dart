import 'AuthStatus.dart';

/*----------------------------------------------

ユーザーエンティティクラス

----------------------------------------------*/
class User {
  String _userId = "";
  String _name = "";
  String _age = "";
  String _sex = "";
  String _rank = "0";
  Map _event;
  AuthStatus _status;

  User();
  User.tmpUser(this._status, this._userId);

  User.fromMap(String userId, Map map)
      : _userId = userId,
        _name = map["name"],
        _age = map["age"],
        _sex = map["sex"],
        _rank = map["rank"],
        _status = AuthStatus.signedIn;

  toJson() {
    print("\n-----------send Data-----------\n"
        "userId:$userId\n"
        "name:$name\n"
        "age:$age\n"
        "sex:$sex\n"
        "rank:$rank\n"
        "-------------------------------\n");
    return {
      "userId": userId,
      "name": name,
      "age": age,
      "sex": sex,
      "rank": rank,
    };
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get name => _name;
  set name(String value) {
    _name = value;
  }

  Map get event => _event;
  set event(Map value) {
    _event = value;
  }

  String get rank => _rank;
  set rank(String value) {
    _rank = value;
  }

  String get sex => _sex;
  set sex(String value) {
    _sex = value;
  }

  String get age => _age;
  set age(String value) {
    _age = value;
  }

  AuthStatus get status => _status;

  set status(AuthStatus value) {
    _status = value;
  }
}
