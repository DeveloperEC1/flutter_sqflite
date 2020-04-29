class Note {
  int _id;
  String _name;
  int _age;

  Note(this._name, this._age);

  int get id => _id;

  String get name => _name;

  int get age => _age;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    if (_id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['age'] = _age;
    return map;
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._age = map['age'];
  }
}
