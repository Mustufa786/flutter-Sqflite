class Note {
  String _name, _date;
  int _id;

  Note.update(this._name, this._date, this._id);

  Note(this._name, this._date);

  Note.map(dynamic obj) {
    this._name = obj['name'];
    this._date = obj['date'];
    this._id = obj['id'];
  }

  Note.fromMap(Map<String, dynamic> map) {
    this._name = map['name'];
    this._id = map['id'];
    this._date = map['date'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();

    map['name'] = this._name;
    map['date'] = this._date;

    if (id != null) map['id'] = this._id;

    return map;
  }

  get name => _name;

  set name(value) {
    _name = value;
  }

  get date => _date;

  set date(value) {
    _date = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
